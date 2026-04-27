import type { Page } from '@playwright/test'

export const FREE_CREDS = {
  email: process.env.TEST_USER_EMAIL,
  password: process.env.TEST_USER_PASSWORD,
} as const

export const PRO_CREDS = {
  email: process.env.TEST_PRO_EMAIL,
  password: process.env.TEST_PRO_PASSWORD,
} as const

export const hasFreeCredentials =
  !!FREE_CREDS.email && !!FREE_CREDS.password

export const hasProCredentials =
  !!PRO_CREDS.email && !!PRO_CREDS.password

interface Credentials {
  email?: string
  password?: string
}

/**
 * Sign in via the email/password form and wait for the dashboard to load.
 *
 * Defaults to the free-tier test user (TEST_USER_EMAIL / TEST_USER_PASSWORD).
 * Pass an explicit `creds` object to log in as a different user — typically
 * via the `loginAsPro(page)` shortcut below.
 *
 * Throws if the requested credentials are not set in the environment, so tests
 * that require a logged-in user must be guarded with `hasFreeCredentials` or
 * `hasProCredentials` (see `test.skip(...)` patterns in spec files).
 */
export async function login(
  page: Page,
  creds: Credentials = FREE_CREDS
): Promise<void> {
  if (!creds.email || !creds.password) {
    throw new Error(
      'login() called without credentials. Set TEST_USER_EMAIL/PASSWORD ' +
        '(or TEST_PRO_EMAIL/PASSWORD for loginAsPro) in your environment.'
    )
  }

  await page.goto('/auth/login')
  await page.getByLabel(/email/i).fill(creds.email)
  await page.getByLabel(/password/i).fill(creds.password)
  await page.getByRole('button', { name: /sign in|log in/i }).click()
  await page.waitForURL('**/dashboard', { timeout: 15_000 })
}

export async function loginAsPro(page: Page): Promise<void> {
  return login(page, PRO_CREDS)
}
