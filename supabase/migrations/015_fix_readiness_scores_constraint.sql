-- Fix readiness_scores to support multiple exams per user.
-- The original schema had a unique constraint on user_id alone, which prevents
-- a user from having a separate readiness score per exam.

-- Drop single-column unique constraint
alter table public.readiness_scores
  drop constraint readiness_scores_user_id_key;

-- Add composite unique constraint so upsert can target (user_id, exam_id)
alter table public.readiness_scores
  add constraint readiness_scores_user_id_exam_id_key unique (user_id, exam_id);

-- Add missing INSERT policy (upserts for new users were blocked by RLS)
create policy "Users can insert own readiness" on public.readiness_scores
  for insert with check (auth.uid() = user_id);
