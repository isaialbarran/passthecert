import { test, expect, type Page } from '@playwright/test'

const hasTestCredentials =
  !!process.env.TEST_USER_EMAIL && !!process.env.TEST_USER_PASSWORD

async function login(page: Page): Promise<void> {
  await page.goto('/auth/login')
  await page.getByLabel(/email/i).fill(process.env.TEST_USER_EMAIL!)
  await page.getByLabel(/password/i).fill(process.env.TEST_USER_PASSWORD!)
  await page.getByRole('button', { name: /sign in|log in/i }).click()
  await page.waitForURL('**/dashboard', { timeout: 15_000 })
}

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
    await expect(page.getByText(/€\d+\.\d{2}\/mo/)).toBeVisible()
    await expect(page.getByText(/unlimited questions/i)).toBeVisible()
  })

  test('unauthenticated user on pricing sees login CTA', async ({ page }) => {
    await page.goto('/pricing')
    const cta = page.getByRole('link', { name: /subscribe/i })
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
  test.skip(!hasTestCredentials, 'TEST_USER_EMAIL and TEST_USER_PASSWORD not set')

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

  test('pricing page for authenticated free user shows checkout button', async ({
    page,
  }) => {
    await page.goto('/pricing')
    // Authenticated non-pro user sees submit button (form action) or "already subscribed"
    const checkoutBtn = page.getByRole('button', {
      name: /subscribe/i,
    })
    const alreadySubscribed = page.getByText(/already have an active/i)

    const hasCheckout = await checkoutBtn.isVisible()
    const hasSubscription = await alreadySubscribed.isVisible()

    // One of these two states must be true
    expect(hasCheckout || hasSubscription).toBe(true)
  })

  test('checkout button redirects to Stripe', async ({ page }) => {
    await page.goto('/pricing')
    const checkoutBtn = page.getByRole('button', {
      name: /subscribe/i,
    })

    const isVisible = await checkoutBtn.isVisible()

    // Skip if user is already Pro (no checkout button shown)
    test.skip(!isVisible, 'User is already subscribed — skipping checkout test')

    // Click and wait for navigation to Stripe
    await checkoutBtn.click()
    await page.waitForURL(/checkout\.stripe\.com/, { timeout: 30_000 })
  })

  test('settings page loads with billing section', async ({ page }) => {
    await page.goto('/settings')
    await expect(page.getByRole('heading', { name: /billing/i })).toBeVisible({
      timeout: 10_000,
    })
  })
})
