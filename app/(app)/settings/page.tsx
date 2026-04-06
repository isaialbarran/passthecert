import { requireAuth } from '@/features/auth'
import {
  getSubscriptionStatus,
  createPortalAndRedirect,
  updatePaymentMethodAndRedirect,
  cancelSubscriptionAndRedirect,
} from '@/features/billing'
import type { SubscriptionStatus } from '@/features/billing'

function StatusBadge({ status }: { status: SubscriptionStatus }): React.ReactElement {
  const config: Record<
    string,
    { label: string; className: string }
  > = {
    active: {
      label: 'Active',
      className: 'bg-accent/10 text-accent border-accent/30',
    },
    trialing: {
      label: 'Trial',
      className: 'bg-accent/10 text-accent border-accent/30',
    },
    canceled: {
      label: 'Canceled',
      className: 'bg-muted/10 text-muted border-muted/30',
    },
    past_due: {
      label: 'Past due',
      className: 'bg-danger/10 text-danger border-danger/30',
    },
    unpaid: {
      label: 'Unpaid',
      className: 'bg-danger/10 text-danger border-danger/30',
    },
  }

  const fallback = {
    label: 'No subscription',
    className: 'bg-muted/10 text-muted border-muted/30',
  }

  const { label, className } = config[status ?? ''] ?? fallback

  return (
    <span
      className={`inline-flex items-center rounded-full border px-3 py-1 text-xs font-medium ${className}`}
    >
      {label}
    </span>
  )
}

export default async function SettingsPage(): Promise<React.ReactElement> {
  const user = await requireAuth()
  const status = await getSubscriptionStatus(user.id)

  return (
    <div className="space-y-8">
      <h1 className="font-heading text-2xl font-extrabold text-foreground">
        Settings
      </h1>

      <section className="rounded-lg border border-border bg-surface p-6 space-y-6">
        <div className="flex items-center justify-between">
          <h2 className="font-heading text-lg font-extrabold text-foreground">
            Billing
          </h2>
          <StatusBadge status={status} />
        </div>

        <p className="text-sm text-muted">
          Manage your subscription, payment method, and invoices through the
          Stripe portal.
        </p>

        <div className="flex flex-wrap gap-3">
          <form action={updatePaymentMethodAndRedirect}>
            <button
              type="submit"
              className="rounded-md border border-border bg-surface px-4 py-2 text-sm font-medium text-foreground transition-colors hover:bg-accent/10 hover:border-accent/30"
            >
              Update payment method
            </button>
          </form>

          <form action={createPortalAndRedirect}>
            <button
              type="submit"
              className="rounded-md border border-border bg-surface px-4 py-2 text-sm font-medium text-foreground transition-colors hover:bg-accent/10 hover:border-accent/30"
            >
              View invoices
            </button>
          </form>

          <form action={cancelSubscriptionAndRedirect}>
            <button
              type="submit"
              className="rounded-md border border-border bg-surface px-4 py-2 text-sm font-medium text-danger transition-colors hover:bg-danger/10 hover:border-danger/30"
            >
              Cancel subscription
            </button>
          </form>
        </div>
      </section>
    </div>
  )
}
