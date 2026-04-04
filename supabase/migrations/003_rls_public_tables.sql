-- Enable RLS on questions: only authenticated users can read active questions
-- This prevents anonymous users from scraping the question bank (including correct_key)
-- via the Supabase REST API with the anon key.
-- Diagnostic flows use createAdminClient() server-side to bypass RLS.
ALTER TABLE public.questions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can read active questions"
  ON public.questions
  FOR SELECT
  TO authenticated
  USING (is_active = true);

-- Enable RLS on exams: public read for marketing pages, only active exams
ALTER TABLE public.exams ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read active exams"
  ON public.exams
  FOR SELECT
  USING (is_active = true);

-- Enable RLS on domains: public read (diagnostic needs domain info for anonymous users)
ALTER TABLE public.domains ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read domains"
  ON public.domains
  FOR SELECT
  USING (true);

-- Fix: readiness_scores missing INSERT policy
-- Without this, the first upsert in updateReadinessScore silently fails for new users.
CREATE POLICY "Users can insert own readiness"
  ON public.readiness_scores
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);
