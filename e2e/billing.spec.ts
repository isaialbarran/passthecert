import { test, expect } from '@playwright/test'
import { hasFreeCredentials, login } from './helpers'

const hasRealStripeKey =
  process.env.STRIPE_SECRET_KEY?.startsWith('sk_test_') === true &&
  process.env.STRIPE_SECRET_KEY !== 'sk_test_dummy'

test.describe('Billing — pricing page CTA', () => {
  test('Anonymous user on /pricing sees a CTA that links to login', async ({
    page,
  }) => {
    await page.goto('/pricing')

    const cta = page.getByRole('link', { name: /free trial/i })
    await expect(cta).toBeVisible({ timeout: 10_000 })
    await expect(cta).toHaveAttribute('href', /\/auth\/login/)
  })

  test('Pricing page shows €14.99/mo and the 7-day guarantee copy', async ({
    page,
  }) => {
    await page.goto('/pricing')

    await expect(
      page.getByRole('heading', { name: 'Pro', level: 2 })
    ).toBeVisible({ timeout: 10_000 })
    await expect(page.getByText(/€14\.99/).first()).toBeVisible()
    await expect(page.getByText(/cancel anytime/i)).toBeVisible()
  })
})

test.describe('Billing — BILL-02: authenticated free user → Stripe Checkout', () => {
  test.skip(
    !hasFreeCredentials,
    'TEST_USER_EMAIL / TEST_USER_PASSWORD not set'
  )

  test.beforeEach(async ({ page }) => {
    await login(page)
  })

  test('Authenticated free user sees a checkout submit button on /pricing', async ({
    page,
  }) => {
    await page.goto('/pricing')

    const checkoutBtn = page.getByRole('button', { name: /free trial/i })
    const alreadySubscribed = page.getByText(/already have an active/i)

    // Test account must be in one of these two states.
    const seesCheckout = await checkoutBtn.isVisible()
    const seesAlreadySubscribed = await alreadySubscribed.isVisible()

    expect(seesCheckout || seesAlreadySubscribed).toBe(true)

    // If we got here as a free user, the form must POST (Server Action) — i.e.
    // the button is wrapped in a <form>. RSC server actions submit a POST to
    // the same URL with a form-encoded payload, and Stripe's redirect comes
    // back as a 303.
    if (seesCheckout) {
      const form = checkoutBtn.locator('xpath=ancestor::form').first()
      await expect(form).toBeAttached()
    }
  })

  test('BILL-02: clicking the upgrade button redirects to checkout.stripe.com', async ({
    page,
  }) => {
    test.skip(
      !hasRealStripeKey,
      'STRIPE_SECRET_KEY is missing or set to a placeholder — Stripe checkout cannot be created'
    )

    await page.goto('/pricing')

    const checkoutBtn = page.getByRole('button', { name: /free trial/i })
    const isFreeUser = await checkoutBtn.isVisible()

    test.skip(
      !isFreeUser,
      'Test account is already subscribed; reset it in Supabase to subscription_status=inactive to run this test.'
    )

    // The Server Action returns a Stripe URL via redirect(). Playwright will
    // follow the 303 and end up on checkout.stripe.com.
    await checkoutBtn.click()
    await page.waitForURL(/checkout\.stripe\.com/, { timeout: 30_000 })

    // Sanity-check the URL shape: a real Stripe Checkout URL looks like
    // https://checkout.stripe.com/c/pay/cs_test_... (or live equivalent)
    expect(page.url()).toMatch(
      /^https:\/\/checkout\.stripe\.com\/(c\/)?pay\//
    )
  })
})
