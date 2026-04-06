import { requireAuth, getProfile } from '@/features/auth'
import { createClient } from '@/shared/lib/supabase'
import {
  getReadinessScore,
  getDomainMastery,
  getStudyStreak,
  getQuestionsMastered,
  getWrongAnswersCount,
} from '@/features/progress'
import { DashboardGreeting } from '@/features/progress/components/dashboard-greeting'
import { DomainMastery } from '@/features/progress/components/domain-mastery'
import { StartPracticeCta } from '@/features/progress/components/start-practice-cta'
import { isPro, UpgradeBanner, UpgradeSuccessBanner } from '@/features/billing'

interface DashboardPageProps {
  searchParams: Promise<{ upgraded?: string }>
}

export default async function DashboardPage({ searchParams }: DashboardPageProps) {
  const { upgraded } = await searchParams
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

  const [readiness, domainMastery, streak, mastered, wrongAnswersCount, userIsPro, profile] =
    await Promise.all([
      getReadinessScore(user.id, exam.id),
      getDomainMastery(user.id, exam.id),
      getStudyStreak(user.id),
      getQuestionsMastered(user.id),
      getWrongAnswersCount(user.id),
      isPro(user.id),
      getProfile(user.id),
    ])

  const firstName =
    profile?.full_name?.split(' ')[0]?.trim() ||
    profile?.email?.split('@')[0] ||
    'there'

  return (
    <div className="space-y-8">
      <DashboardGreeting
        firstName={firstName}
        readinessScore={readiness?.overall_score ?? 0}
        streak={streak}
        mastered={mastered}
      />

      {upgraded === 'true' && !userIsPro && <UpgradeSuccessBanner />}
      {userIsPro ? (
        <StartPracticeCta examSlug={exam.slug} hasMistakes={wrongAnswersCount > 0} />
      ) : (
        <UpgradeBanner />
      )}

      <DomainMastery domains={domainMastery} examSlug={exam.slug} />
    </div>
  )
}
