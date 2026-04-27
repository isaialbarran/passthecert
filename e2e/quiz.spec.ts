import { test, expect, type Page } from '@playwright/test'
import { hasProCredentials, loginAsPro } from './helpers'

const SECURITY_PLUS_SLUG = 'comptia-security-plus'
const QUIZ_URL = `/quiz/${SECURITY_PLUS_SLUG}?mode=random_10`

/**
 * Click an option button by its key (A | B | C | D).
 *
 * The QuestionCard renders the key inside a small badge span, so the visible
 * text of the button starts with the key character — same pattern that the
 * diagnostic spec already relies on.
 */
async function selectOption(
  page: Page,
  key: 'A' | 'B' | 'C' | 'D'
): Promise<void> {
  await page.locator('button').filter({ hasText: new RegExp(`^${key}`) }).first().click()
}

async function submitAndWaitForFeedback(page: Page): Promise<void> {
  await page.getByRole('button', { name: /submit answer/i }).click()
  // ExplanationPanel renders a <p> with literally "Correct!" or "Incorrect"
  await expect(
    page.getByText(/^(Correct!|Incorrect)$/)
  ).toBeVisible({ timeout: 10_000 })
}

test.describe('Quiz Engine — random_10 (P0 revenue path)', () => {
  test.skip(
    !hasProCredentials,
    'TEST_PRO_EMAIL / TEST_PRO_PASSWORD not set — quiz tests need a Pro user (free users hit the paywall)'
  )

  test.beforeEach(async ({ page }) => {
    await loginAsPro(page)
  })

  test('QUIZ-01: starting random_10 renders Q1 with a stem and 4 lettered options', async ({
    page,
  }) => {
    await page.goto(QUIZ_URL)

    await expect(page.getByText('Question 1 of 10')).toBeVisible({
      timeout: 15_000,
    })

    // Stem renders in the first <h2>
    const stem = page.locator('h2').first()
    await expect(stem).toBeVisible()
    const stemText = (await stem.textContent())?.trim() ?? ''
    expect(stemText.length).toBeGreaterThan(10)

    // 4 option buttons (A, B, C, D)
    for (const key of ['A', 'B', 'C', 'D'] as const) {
      const optionBtn = page
        .locator('button')
        .filter({ hasText: new RegExp(`^${key}`) })
        .first()
      await expect(optionBtn).toBeVisible()
      await expect(optionBtn).toBeEnabled()
    }

    // Submit Answer is disabled until an option is chosen
    await expect(
      page.getByRole('button', { name: /submit answer/i })
    ).toBeDisabled()
  })

  test('QUIZ-02: submitting an answer reveals correct/incorrect feedback', async ({
    page,
  }) => {
    await page.goto(QUIZ_URL)
    await expect(page.getByText('Question 1 of 10')).toBeVisible({
      timeout: 15_000,
    })

    await selectOption(page, 'A')
    await expect(
      page.getByRole('button', { name: /submit answer/i })
    ).toBeEnabled()

    await submitAndWaitForFeedback(page)

    // Once submitted, all option buttons are disabled
    for (const key of ['A', 'B', 'C', 'D'] as const) {
      const optionBtn = page
        .locator('button')
        .filter({ hasText: new RegExp(`^${key}`) })
        .first()
      await expect(optionBtn).toBeDisabled()
    }

    // Submit button is gone, Next Question takes over
    await expect(
      page.getByRole('button', { name: /next question/i })
    ).toBeVisible()
  })

  test('QUIZ-03: submission shows a non-empty explanation', async ({ page }) => {
    await page.goto(QUIZ_URL)
    await expect(page.getByText('Question 1 of 10')).toBeVisible({
      timeout: 15_000,
    })

    await selectOption(page, 'A')
    await submitAndWaitForFeedback(page)

    // Inside ExplanationPanel: <p>Correct!/Incorrect</p><p>{explanation}</p>
    // The explanation is the sibling <p> after the Correct/Incorrect label.
    const explanationP = page
      .getByText(/^(Correct!|Incorrect)$/)
      .locator('xpath=following-sibling::p')
      .first()
    await expect(explanationP).toBeVisible()

    const explanation = (await explanationP.textContent())?.trim() ?? ''
    // INSTRUCTIONS.md §6.2: "Show full explanation immediately"
    // Real explanations from the bank are 100+ chars; 20 is a generous floor
    // that still catches an empty/missing field.
    expect(explanation.length).toBeGreaterThan(20)
  })

  test('QUIZ-04: clicking Next Question advances to question 2', async ({
    page,
  }) => {
    await page.goto(QUIZ_URL)
    await expect(page.getByText('Question 1 of 10')).toBeVisible({
      timeout: 15_000,
    })

    const q1Stem = await page.locator('h2').first().textContent()

    await selectOption(page, 'A')
    await submitAndWaitForFeedback(page)

    await page.getByRole('button', { name: /next question/i }).click()

    await expect(page.getByText('Question 2 of 10')).toBeVisible({
      timeout: 15_000,
    })

    const q2Stem = await page.locator('h2').first().textContent()
    expect(q2Stem).not.toBe(q1Stem)

    // Feedback panel from Q1 must be gone
    await expect(page.getByText(/^(Correct!|Incorrect)$/)).not.toBeVisible()
  })

  test('QUIZ-06: completing all 10 questions shows the results screen', async ({
    page,
  }) => {
    test.setTimeout(120_000)

    await page.goto(QUIZ_URL)
    await expect(page.getByText('Question 1 of 10')).toBeVisible({
      timeout: 15_000,
    })

    for (let i = 1; i <= 10; i++) {
      await selectOption(page, 'A')
      await submitAndWaitForFeedback(page)
      await page.getByRole('button', { name: /next question/i }).click()

      if (i < 10) {
        await expect(page.getByText(`Question ${i + 1} of 10`)).toBeVisible({
          timeout: 15_000,
        })
      }
    }

    // Completion screen
    await expect(
      page.getByRole('heading', { name: /quiz complete/i })
    ).toBeVisible({ timeout: 20_000 })

    // "You got X out of 10 questions"
    await expect(page.getByText(/out of 10 questions/i)).toBeVisible()

    // Back to Dashboard link is reachable
    await expect(
      page.getByRole('link', { name: /back to dashboard/i })
    ).toHaveAttribute('href', '/dashboard')
  })
})

test.describe('Quiz Engine — auth gating', () => {
  test('Unauthenticated user is redirected from /quiz/* to /auth/login', async ({
    page,
  }) => {
    await page.goto(QUIZ_URL)
    await expect(page).toHaveURL(/\/auth\/login/, { timeout: 10_000 })
  })
})
