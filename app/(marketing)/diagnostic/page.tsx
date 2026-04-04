import type { Metadata } from 'next'
import { getDiagnosticQuestions } from '@/features/diagnostic/queries'
import { DiagnosticClient } from '@/features/diagnostic/components/diagnostic-client'

export const metadata: Metadata = {
  title: 'Free Security+ Diagnostic — PassTheCert',
  description:
    'Take a free 10-question diagnostic test across all 5 CompTIA Security+ (SY0-701) domains. See your score instantly and get a personalized study plan.',
}

export default async function DiagnosticPage(): Promise<React.JSX.Element> {
  const questions = await getDiagnosticQuestions('comptia-security-plus')

  return (
    <main className="px-4 py-12">
      <DiagnosticClient questions={questions} />
    </main>
  )
}
