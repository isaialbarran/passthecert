export interface Profile {
  id: string
  email: string
  full_name: string | null
  avatar_url: string | null
  stripe_customer_id: string | null
  subscription_status: 'trialing' | 'active' | 'canceled' | 'past_due'
  subscription_tier: 'free' | 'pro'
  trial_ends_at: string | null
  created_at: string
  updated_at: string
}

export interface Exam {
  id: string
  slug: string
  name: string
  vendor: string
  total_questions: number
  pass_score: number
  duration_mins: number
  is_active: boolean
  created_at: string
}

export interface Domain {
  id: string
  exam_id: string
  name: string
  code: string
  weight_pct: number
  created_at: string
}

export interface QuestionOption {
  key: string
  text: string
}

export interface Question {
  id: string
  exam_id: string
  domain_id: string | null
  stem: string
  options: QuestionOption[]
  correct_key: string
  explanation: string
  difficulty: 'easy' | 'medium' | 'hard'
  question_type: 'single' | 'multi'
  tags: string[]
  is_active: boolean
  created_at: string
}

export interface UserResponse {
  id: string
  user_id: string
  question_id: string
  selected_key: string
  is_correct: boolean
  time_spent_secs: number | null
  repetitions: number
  ease_factor: number
  interval_days: number
  next_review_at: string
  session_id: string | null
  created_at: string
}

export interface QuizSession {
  id: string
  user_id: string
  exam_id: string
  mode: 'random_10' | 'full_exam' | 'review_mistakes' | 'domain_focus'
  domain_id: string | null
  total_questions: number
  correct_count: number
  score_pct: number | null
  is_completed: boolean
  completed_at: string | null
  created_at: string
}

export interface ReadinessScore {
  id: string
  user_id: string
  exam_id: string
  overall_score: number
  domain_scores: Record<string, number>
  questions_seen: number
  questions_mastered: number
  current_streak: number
  last_activity_at: string | null
  updated_at: string
}
