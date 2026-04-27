import { test, expect } from '@playwright/test'
import { hasFreeCredentials, login } from './helpers'

test.describe('Smoke Test — Critical User Flows', () => {
  test('landing page loads and links to pricing', async ({ page }) => {
    await page.goto('/')
    await expect(page).toHaveTitle(/.+/)
    const pricingLink = page.getByRole('link', { name: /pricing/i })
    await expect(pricingLink).toBeVisible({ timeout: 10_000 })
  })

  test('pricing page shows plan details and CTA', async ({ page }) => {
    await page.goto('/pricing')
    await expect(page.getByRole('heading', { name: 'Pro', level: 2 })).toBeVisible({ timeout: 10_000 })
    await expect(page.getByText(/€\d+\.\d{2}\/mo/).first()).toBeVisible()
    await expect(page.getByText(/unlimited questions/i)).toBeVisible()
  })

  test('unauthenticated user on pricing sees login CTA', async ({ page }) => {
    await page.goto('/pricing')
    const cta = page.getByRole('link', { name: /free trial/i })
    await expect(cta).toBeVisible({ timeout: 10_000 })
    await expect(cta).toHaveAttribute('href', /\/auth\/login/)
  })

  test('unauthenticated user is redirected from dashboard to login', async ({
    page,
  }) => {
    await page.goto('/dashboard')
    await expect(page).toHaveURL(/\/auth\/login/, { timeout: 10_000 })
  })

  test('diagnostic quiz is accessible without login', async ({ page }) => {
    await page.goto('/diagnostic')
    await expect(
      page.getByRole('button', { name: 'Start Diagnostic' })
    ).toBeVisible({ timeout: 15_000 })
  })
})

test.describe('Smoke Test — Authenticated Flows', () => {
  test.skip(!hasFreeCredentials, 'TEST_USER_EMAIL and TEST_USER_PASSWORD not set')

  test.beforeEach(async ({ page }) => {
    await login(page)
  })

  test('dashboard loads with greeting and stats', async ({ page }) => {
    await expect(page.getByTestId('dashboard-greeting')).toBeVisible({
      timeout: 10_000,
    })
    await expect(page.getByTestId('stat-readiness')).toBeVisible()
    await expect(page.getByTestId('stat-streak')).toBeVisible()
    await expect(page.getByTestId('stat-mastered')).toBeVisible()
  })

  test('settings page loads with billing section', async ({ page }) => {
    await page.goto('/settings')
    await expect(page.getByRole('heading', { name: /billing/i })).toBeVisible({
      timeout: 10_000,
    })
  })
})
