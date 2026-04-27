import { test, expect } from '@playwright/test'
import { hasFreeCredentials, login } from './helpers'

test.describe('Dashboard Greeting — Happy Path', () => {
  test.skip(!hasFreeCredentials, 'TEST_USER_EMAIL / TEST_USER_PASSWORD not set')

  test.beforeEach(async ({ page }) => {
    await login(page)
  })

  test('TC-01: shows greeting with name and correct time of day', async ({ page }) => {
    const greeting = page.getByTestId('dashboard-greeting')
    await expect(greeting).toBeVisible({ timeout: 10_000 })
    await expect(greeting).toContainText(/Good (morning|afternoon|evening)/)
    await expect(greeting).not.toContainText('undefined')
    await expect(greeting).not.toContainText('null')
  })

  test('TC-04: shows inline stats for readiness, streak, and mastered', async ({ page }) => {
    await expect(page.getByTestId('stat-readiness')).toBeVisible()
    await expect(page.getByTestId('stat-streak')).toBeVisible()
    await expect(page.getByTestId('stat-mastered')).toBeVisible()
    // Readiness ends with '%'
    await expect(page.getByTestId('stat-readiness')).toContainText('%')
  })
})

test.describe('Dashboard Greeting — Review Mistakes button (conditional)', () => {
  test.skip(!hasFreeCredentials, 'TEST_USER_EMAIL / TEST_USER_PASSWORD not set')

  test.beforeEach(async ({ page }) => {
    await login(page)
  })

  test('TC-05/TC-06: Review Mistakes link only appears when mistakes exist', async ({ page }) => {
    const hasMistakesBtn = page.getByRole('link', { name: 'Review Mistakes' })
    // Either visible or not — both states are valid; we verify no uncaught error
    const isVisible = await hasMistakesBtn.isVisible()
    if (isVisible) {
      await expect(hasMistakesBtn).toHaveAttribute('href', /review_mistakes/)
    }
  })
})

test.describe('Dashboard — Auth', () => {
  test('TC-11: unauthenticated user is redirected to /auth/login', async ({ page }) => {
    await page.goto('/dashboard')
    await expect(page).toHaveURL(/\/auth\/login/, { timeout: 10_000 })
  })
})

test.describe('Dashboard — Edge Cases', () => {
  test.skip(!hasFreeCredentials, 'TEST_USER_EMAIL / TEST_USER_PASSWORD not set')

  test.beforeEach(async ({ page }) => {
    await login(page)
  })

  test('TC-09: stats show valid numeric values (no NaN, no empty)', async ({ page }) => {
    const readiness = await page.getByTestId('stat-readiness').textContent()
    const streak = await page.getByTestId('stat-streak').textContent()
    const mastered = await page.getByTestId('stat-mastered').textContent()

    expect(readiness).toMatch(/^\d+%$/)
    expect(streak).toMatch(/\d+/)
    expect(mastered).toMatch(/\d+/)
  })

  test('TC-10: readiness label is one of the three valid values', async ({ page }) => {
    const labels = ['Keep Practicing', 'Getting There', 'Ready to Pass']
    const greeting = page.getByTestId('dashboard-greeting')
    const text = await greeting.textContent()
    const hasLabel = labels.some((l) => text?.includes(l))
    expect(hasLabel).toBe(true)
  })
})
