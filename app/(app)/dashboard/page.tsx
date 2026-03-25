import { requireAuth } from '@/features/auth'
import { createClient } from '@/shared/lib/supabase'
import {
  getReadinessScore,
  getDomainMastery,
  getStudyStreak,
  getQuestionsMastered,
  getRecentSessions,
} from '@/features/progress'
import { ReadinessCard } from '@/features/progress/components/readiness-card'
import { DomainMastery } from '@/features/progress/components/domain-mastery'
import { StudyStreak } from '@/features/progress/components/study-streak'
import { RecentSessions } from '@/features/progress/components/recent-sessions'
import { StartPracticeCta } from '@/features/progress/components/start-practice-cta'

export default async function DashboardPage() {
  const user = await requireAuth()
  const supabase = await createClient()

  const { data: exam } = await supabase
    .from('exams')
    .select('id, slug')
    .eq('slug', 'comptia-security-plus')
    .single()

  if (!exam) {
    return <p className="text-muted">No exam configured.</p>
  }

  const [readiness, domainMastery, streak, mastered, recentSessions] =
    await Promise.all([
      getReadinessScore(user.id, exam.id),
      getDomainMastery(user.id, exam.id),
      getStudyStreak(user.id),
      getQuestionsMastered(user.id),
      getRecentSessions(user.id),
    ])

  return (
    <div className="space-y-8">
      <div>
        <h1 className="font-heading text-3xl font-extrabold">Dashboard</h1>
        <p className="mt-1 text-sm text-muted">
          CompTIA Security+ (SY0-701)
        </p>
      </div>

      <div className="grid gap-6 md:grid-cols-3">
        <ReadinessCard score={readiness?.overall_score ?? 0} />
        <StudyStreak streak={streak} />
        <div className="rounded-lg border border-border bg-surface p-6">
          <p className="text-sm text-muted">Questions Mastered</p>
          <p className="mt-2 font-heading text-4xl font-extrabold text-accent">
            {mastered}
          </p>
          <p className="mt-1 text-xs text-muted">
            Answered correctly 3+ times
          </p>
        </div>
      </div>

      <DomainMastery domains={domainMastery} />
      <RecentSessions sessions={recentSessions} />
      <StartPracticeCta examSlug={exam.slug} />
    </div>
  )
}
