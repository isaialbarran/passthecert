import { test, expect, type Page } from '@playwright/test'

const ANSWERS_KEY = 'diagnostic_answers'
const TIMER_KEY = 'diagnostic_timer_start'

async function gotoIntro(page: Page): Promise<void> {
  await page.goto('/diagnostic')
  await expect(page.getByRole('button', { name: 'Start Diagnostic' })).toBeVisible({
    timeout: 15_000,
  })
}

async function startQuiz(page: Page): Promise<void> {
  await gotoIntro(page)
  await page.getByRole('button', { name: 'Start Diagnostic' }).click()
  await expect(page.getByText(/Question 1 of/)).toBeVisible({ timeout: 10_000 })
}

async function selectFirstOptionAndAdvance(page: Page): Promise<void> {
  // Options render as buttons with text like "A Confidentiality"
  await page.locator('button').filter({ hasText: /^A/ }).first().click()
  const btn = page.getByRole('button', { name: /Next Question|See Results/ })
  await expect(btn).toBeEnabled()
  await btn.click()
}

test.describe('Diagnostic quiz', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/diagnostic')
    await page.evaluate((keys: string[]) => {
      keys.forEach((k) => localStorage.removeItem(k))
    }, [ANSWERS_KEY, TIMER_KEY])
  })

  test('TC-01: intro muestra 10 preguntas, 5 dominios y 10 min', async ({ page }) => {
    await gotoIntro(page)
    await expect(page.getByRole('heading', { name: /Security\+ Diagnostic/i })).toBeVisible()
    // Use exact match to avoid strict-mode violation with "10 questions across..." paragraph
    await expect(page.getByText('10', { exact: true })).toBeVisible()
    await expect(page.getByText('5', { exact: true })).toBeVisible()
    await expect(page.getByText('10 min', { exact: true })).toBeVisible()
  })

  test('TC-02: timer aparece en esquina superior derecha al iniciar', async ({ page }) => {
    await startQuiz(page)
    await expect(page.getByText('Time Remaining')).toBeVisible()
    // Timer starts near 10:00 — matches 09:xx or 10:00
    const timerText = await page.locator('p.tabular-nums').textContent()
    expect(timerText).toMatch(/^(10:00|09:)/)
  })

  test('TC-03: responder pregunta no muestra feedback — carga siguiente de inmediato', async ({
    page,
  }) => {
    await startQuiz(page)
    const q1Text = await page.locator('h2').textContent()

    await selectFirstOptionAndAdvance(page)

    // Wait for the question counter to advance before reading h2
    await expect(page.getByText(/Question 2 of/)).toBeVisible({ timeout: 10_000 })

    const q2Text = await page.locator('h2').textContent()
    expect(q2Text).not.toBe(q1Text)

    // No feedback shown (no green/red/explanation)
    await expect(page.getByText(/Correct|Incorrect|Explanation/i)).not.toBeVisible()
  })

  test('TC-04: progress bar muestra fill en Q1 y más fill en Q2', async ({ page }) => {
    await startQuiz(page)
    const bar = page.locator('.bg-accent.rounded-full').last()

    // Q1: (currentIndex+1)/total*100 — must be > 0
    const w1 = await bar.evaluate((el: HTMLElement) => el.style.width)
    const pct1 = parseFloat(w1)
    expect(pct1).toBeGreaterThan(0)

    await selectFirstOptionAndAdvance(page)

    // Wait for Q2 to render before reading the bar
    await expect(page.getByText(/Question 2 of/)).toBeVisible({ timeout: 10_000 })

    const w2 = await bar.evaluate((el: HTMLElement) => el.style.width)
    const pct2 = parseFloat(w2)
    expect(pct2).toBeGreaterThan(pct1)
  })

  test('TC-05: refresh tras responder Q1 reanuda en Q2', async ({ page }) => {
    await startQuiz(page)
    await selectFirstOptionAndAdvance(page)
    await expect(page.getByText(/Question 2 of/)).toBeVisible()

    await page.reload()

    await expect(page.getByText(/Question 2 of/)).toBeVisible({ timeout: 15_000 })
  })

  test('TC-06: retake limpia localStorage y vuelve al intro', async ({ page }) => {
    await startQuiz(page)

    // Read the total number of questions from the counter
    const counterLocator = page.locator('span.text-muted').filter({ hasText: /Question/ })
    const counterText = await counterLocator.textContent()
    const match = counterText?.match(/of (\d+)/)
    const total = match ? parseInt(match[1]) : 10

    // Inject enough fake completed answers to trigger the results phase on reload
    await page.evaluate(
      ({ key, n }: { key: string; n: number }) => {
        const fakeAnswers = Array.from({ length: n }, (_, i) => ({
          questionId: `q-${i}`,
          selectedKey: 'A',
          isCorrect: true,
          domainId: `domain-${i % 5}`,
        }))
        localStorage.setItem(key, JSON.stringify(fakeAnswers))
      },
      { key: ANSWERS_KEY, n: total }
    )

    await page.reload()

    // Results phase: "Retake Diagnostic" button must appear
    await expect(page.getByRole('button', { name: 'Retake Diagnostic' })).toBeVisible({
      timeout: 15_000,
    })

    await page.getByRole('button', { name: 'Retake Diagnostic' }).click()

    // Back to intro and localStorage cleared
    await expect(page.getByRole('button', { name: 'Start Diagnostic' })).toBeVisible()
    const saved = await page.evaluate((k: string) => localStorage.getItem(k), ANSWERS_KEY)
    expect(saved).toBeNull()
  })
})
