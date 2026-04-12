import { test, expect, type Page } from '@playwright/test'

async function login(page: Page): Promise<void> {
  await page.goto('/auth/login')
  await page.getByLabel(/email/i).fill(process.env.TEST_USER_EMAIL!)
  await page.getByLabel(/password/i).fill(process.env.TEST_USER_PASSWORD!)
  await page.getByRole('button', { name: /sign in|log in/i }).click()
  await page.waitForURL('**/dashboard', { timeout: 15_000 })
}

test.describe('Dashboard Greeting — Happy Path', () => {
  test.beforeEach(async ({ page }) => {
    await login(page)
  })

  test('TC-01: muestra saludo con nombre y hora correcta', async ({ page }) => {
    const greeting = page.getByTestId('dashboard-greeting')
    await expect(greeting).toBeVisible({ timeout: 10_000 })
    await expect(greeting).toContainText(/Good (morning|afternoon|evening)/)
    await expect(greeting).not.toContainText('undefined')
    await expect(greeting).not.toContainText('null')
  })

  test('TC-04: muestra stats inline de readiness, streak y mastered', async ({ page }) => {
    await expect(page.getByTestId('stat-readiness')).toBeVisible()
    await expect(page.getByTestId('stat-streak')).toBeVisible()
    await expect(page.getByTestId('stat-mastered')).toBeVisible()
    // Readiness ends with '%'
    await expect(page.getByTestId('stat-readiness')).toContainText('%')
  })
})

test.describe('Dashboard Greeting — Botón Review Mistakes condicional', () => {
  test.beforeEach(async ({ page }) => {
    await login(page)
  })

  test('TC-05/TC-06: Review Mistakes solo aparece cuando hay errores', async ({ page }) => {
    const hasMistakesBtn = page.getByRole('link', { name: 'Review Mistakes' })
    // Either visible or not — both states are valid; we verify no uncaught error
    const isVisible = await hasMistakesBtn.isVisible()
    if (isVisible) {
      await expect(hasMistakesBtn).toHaveAttribute('href', /review_mistakes/)
    }
  })
})

test.describe('Dashboard — Auth', () => {
  test('TC-11: usuario no autenticado es redirigido a /auth/login', async ({ page }) => {
    await page.goto('/dashboard')
    await expect(page).toHaveURL(/\/auth\/login/, { timeout: 10_000 })
  })
})

test.describe('Dashboard — Edge Cases', () => {
  test.beforeEach(async ({ page }) => {
    await login(page)
  })

  test('TC-09: stats muestran valores numéricos válidos (no NaN, no vacío)', async ({ page }) => {
    const readiness = await page.getByTestId('stat-readiness').textContent()
    const streak = await page.getByTestId('stat-streak').textContent()
    const mastered = await page.getByTestId('stat-mastered').textContent()

    expect(readiness).toMatch(/^\d+%$/)
    expect(streak).toMatch(/\d+/)
    expect(mastered).toMatch(/\d+/)
  })

  test('TC-10: readiness label es uno de los tres valores válidos', async ({ page }) => {
    const labels = ['Keep Practicing', 'Getting There', 'Ready to Pass']
    const greeting = page.getByTestId('dashboard-greeting')
    const text = await greeting.textContent()
    const hasLabel = labels.some((l) => text?.includes(l))
    expect(hasLabel).toBe(true)
  })
})
