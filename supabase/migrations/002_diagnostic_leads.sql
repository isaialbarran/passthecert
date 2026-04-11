-- migrations/002_diagnostic_leads.sql
-- Stores email leads from the diagnostic quiz funnel

create table public.diagnostic_leads (
  id              uuid default gen_random_uuid() primary key,
  email           text not null unique,
  overall_score   int not null check (overall_score between 0 and 100),
  domain_scores   jsonb not null default '{}',
  weakest_domain_id uuid references public.domains(id) on delete set null,
  converted_at    timestamptz,  -- set when user signs up
  created_at      timestamptz default now()
);

alter table public.diagnostic_leads enable row level security;
-- No anon policies — only service role can insert/read

create index diagnostic_leads_email_idx on public.diagnostic_leads(email);
create index diagnostic_leads_converted_at_idx on public.diagnostic_leads(converted_at);
