-- Performance indexes for common query patterns

-- Used by getNextQuestion, submitAnswer (count by session)
CREATE INDEX IF NOT EXISTS idx_user_responses_session
  ON public.user_responses(session_id);

-- Used by getStudyStreak, getDailyQuestionCount (filter by user + date)
CREATE INDEX IF NOT EXISTS idx_user_responses_user_created
  ON public.user_responses(user_id, created_at DESC);

-- Used by getRecentSessions (filter by user + completion + order)
CREATE INDEX IF NOT EXISTS idx_quiz_sessions_user_completed
  ON public.quiz_sessions(user_id, is_completed, created_at DESC);

-- Foreign key: user_responses.session_id -> quiz_sessions.id
-- Prevents orphaned response records
ALTER TABLE public.user_responses
  ADD CONSTRAINT fk_user_responses_session
  FOREIGN KEY (session_id) REFERENCES public.quiz_sessions(id);

-- Atomic increment function for quiz session correct_count
-- Prevents race condition from concurrent read-then-write pattern
CREATE OR REPLACE FUNCTION public.increment_correct_count(session_id uuid)
RETURNS void
LANGUAGE sql
SECURITY DEFINER
AS $$
  UPDATE public.quiz_sessions
  SET correct_count = correct_count + 1
  WHERE id = session_id;
$$;
