-- migrations/001_initial_schema.sql

-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- ─── USERS ───────────────────────────────────────────────────────────────────
-- Extends Supabase auth.users with app-specific profile data
create table public.profiles (
  id            uuid references auth.users(id) on delete cascade primary key,
  email         text not null,
  full_name     text,
  avatar_url    text,
  -- Subscription
  stripe_customer_id    text unique,
  subscription_status   text default 'trialing', -- trialing | active | canceled | past_due
  subscription_tier     text default 'free',      -- free | pro
  trial_ends_at         timestamptz,
  -- Metadata
  created_at    timestamptz default now(),
  updated_at    timestamptz default now()
);

-- RLS: users can only read/write their own profile
alter table public.profiles enable row level security;
create policy "Users can view own profile" on public.profiles for select using (auth.uid() = id);
create policy "Users can update own profile" on public.profiles for update using (auth.uid() = id);

-- ─── EXAMS ───────────────────────────────────────────────────────────────────
-- Certification metadata (Security+, AWS, etc.)
create table public.exams (
  id            uuid default uuid_generate_v4() primary key,
  slug          text unique not null,         -- 'comptia-security-plus'
  name          text not null,                -- 'CompTIA Security+ (SY0-701)'
  vendor        text not null,                -- 'CompTIA'
  total_questions int default 90,
  pass_score    int default 750,              -- Out of 900
  duration_mins int default 90,
  is_active     boolean default true,
  created_at    timestamptz default now()
);

-- ─── DOMAINS ─────────────────────────────────────────────────────────────────
-- Exam domains (topics). Security+ has 5 domains.
create table public.domains (
  id            uuid default uuid_generate_v4() primary key,
  exam_id       uuid references public.exams(id) on delete cascade,
  name          text not null,                -- 'Threats, Attacks and Vulnerabilities'
  code          text not null,                -- '1.0'
  weight_pct    int not null,                 -- 24 (% of exam questions)
  created_at    timestamptz default now()
);

-- ─── QUESTIONS ───────────────────────────────────────────────────────────────
create table public.questions (
  id            uuid default uuid_generate_v4() primary key,
  exam_id       uuid references public.exams(id) on delete cascade,
  domain_id     uuid references public.domains(id) on delete set null,
  -- Content
  stem          text not null,                -- The question text
  options       jsonb not null,               -- [{"key":"A","text":"..."},{"key":"B","text":"..."}]
  correct_key   text not null,                -- 'A' | 'B' | 'C' | 'D'
  explanation   text not null,                -- Why the answer is correct (required, no exceptions)
  -- Metadata
  difficulty    text default 'medium',        -- easy | medium | hard
  question_type text default 'single',        -- single | multi (multiple correct answers)
  tags          text[] default '{}',          -- ['encryption', 'PKI', 'certificates']
  is_active     boolean default true,
  created_at    timestamptz default now()
);

-- Index for fast filtered queries
create index questions_exam_id_idx on public.questions(exam_id);
create index questions_domain_id_idx on public.questions(domain_id);

-- ─── USER RESPONSES ──────────────────────────────────────────────────────────
-- Every single answer attempt is recorded here. This is the SM-2 engine's input.
create table public.user_responses (
  id              uuid default uuid_generate_v4() primary key,
  user_id         uuid references public.profiles(id) on delete cascade,
  question_id     uuid references public.questions(id) on delete cascade,
  -- Answer data
  selected_key    text not null,
  is_correct      boolean not null,
  time_spent_secs int,                        -- Time to answer in seconds
  -- SM-2 spaced repetition fields
  repetitions     int default 0,              -- How many times answered correctly in a row
  ease_factor     float default 2.5,          -- SM-2 ease factor (min 1.3)
  interval_days   int default 1,              -- Days until next review
  next_review_at  timestamptz default now(),  -- When to show this question again
  -- Session context
  session_id      uuid,                       -- Groups answers from the same quiz session
  created_at      timestamptz default now()
);

-- RLS: users can only see their own responses
alter table public.user_responses enable row level security;
create policy "Users can view own responses" on public.user_responses for select using (auth.uid() = user_id);
create policy "Users can insert own responses" on public.user_responses for insert with check (auth.uid() = user_id);

-- Indexes for SM-2 queries
create index user_responses_user_question_idx on public.user_responses(user_id, question_id);
create index user_responses_next_review_idx on public.user_responses(user_id, next_review_at);

-- ─── QUIZ SESSIONS ───────────────────────────────────────────────────────────
-- Tracks each quiz attempt (Random 10, Full Exam, Review Mistakes)
create table public.quiz_sessions (
  id            uuid default uuid_generate_v4() primary key,
  user_id       uuid references public.profiles(id) on delete cascade,
  exam_id       uuid references public.exams(id),
  -- Session config
  mode          text not null,                -- 'random_10' | 'full_exam' | 'review_mistakes' | 'domain_focus'
  domain_id     uuid references public.domains(id), -- null = all domains
  -- Results (filled when session completes)
  total_questions int not null,
  correct_count   int default 0,
  score_pct       int,                        -- 0-100
  is_completed    boolean default false,
  completed_at    timestamptz,
  created_at      timestamptz default now()
);

alter table public.quiz_sessions enable row level security;
create policy "Users can manage own sessions" on public.quiz_sessions for all using (auth.uid() = user_id);

-- ─── READINESS SCORE ─────────────────────────────────────────────────────────
-- Denormalized for fast dashboard queries. Recalculated after each session.
create table public.readiness_scores (
  id              uuid default uuid_generate_v4() primary key,
  user_id         uuid references public.profiles(id) on delete cascade unique,
  exam_id         uuid references public.exams(id),
  overall_score   int default 0,              -- 0-100 "Ready to Pass" probability
  domain_scores   jsonb default '{}',         -- {"domain_id": score_pct, ...}
  questions_seen  int default 0,
  questions_mastered int default 0,           -- answered correctly 3+ times
  current_streak  int default 0,              -- consecutive study days
  last_activity_at timestamptz,
  updated_at      timestamptz default now()
);

alter table public.readiness_scores enable row level security;
create policy "Users can view own readiness" on public.readiness_scores for select using (auth.uid() = user_id);
create policy "Users can update own readiness" on public.readiness_scores for update using (auth.uid() = user_id);

-- ─── TRIGGERS ────────────────────────────────────────────────────────────────

-- Auto-update updated_at on profiles
create or replace function public.update_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger profiles_updated_at
  before update on public.profiles
  for each row execute function public.update_updated_at();

create trigger readiness_scores_updated_at
  before update on public.readiness_scores
  for each row execute function public.update_updated_at();

-- Auto-create profile + readiness_score on new auth user signup
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, email, full_name, avatar_url)
  values (
    new.id,
    new.email,
    new.raw_user_meta_data->>'full_name',
    new.raw_user_meta_data->>'avatar_url'
  );
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();
