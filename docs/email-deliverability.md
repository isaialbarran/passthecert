# Email Deliverability — passthecert.com

> Goal: every email Resend sends from `reports@passthecert.com` lands in the **inbox** of Gmail / Outlook / iCloud, not spam. This is the lifeline between a diagnostic lead and a paying customer.

## Current state (audited 2026-04-27)

```
SPF      : ❌ MISSING (this is the launch blocker)
DKIM     : ✅ resend._domainkey.passthecert.com publishes a public key
DKIM     : ⚠️ resend2/resend3 selectors not verified — check Resend dashboard
DMARC    : ⚠️ v=DMARC1; p=none;   (works, but no rua → no reports back)
From     : reports@passthecert.com (root domain, not a subdomain)
```

Without SPF, Gmail/Outlook treat the message as unauthenticated even with DKIM — reputation tanks fast.

## Step 1 — Add SPF (P0)

Add a TXT record at the **root** of the domain.

| Field | Value |
|---|---|
| Type | TXT |
| Host / Name | `@` (or `passthecert.com` — depends on the registrar) |
| Value | `v=spf1 include:amazonses.com ~all` |
| TTL | 300 (5 min) — speeds up retries while you tune |

Why `amazonses.com`? Resend sends through AWS SES under the hood. Confirm in the Resend dashboard → Domains → passthecert.com → DNS records — they may show a different `include:` (e.g. `_spf.resend.com`). **Use what the dashboard shows.**

> ⚠️ Only one SPF record is allowed per domain. If one already exists for another sender (e.g. a marketing tool), merge them: `v=spf1 include:amazonses.com include:other.com ~all`.

## Step 2 — Confirm all DKIM selectors are verified

In the Resend dashboard → Domains → passthecert.com:
- Every DKIM CNAME row should show **Verified** (green).
- Resend typically requires **3 selectors** (rotating). The audit only saw `resend._domainkey` resolving — make sure `resend2._domainkey` and `resend3._domainkey` are also added as CNAME records pointing to whatever Resend gives you (usually `*.dkim.amazonses.com`).

Verify each one:
```bash
dig +short CNAME resend._domainkey.passthecert.com
dig +short CNAME resend2._domainkey.passthecert.com
dig +short CNAME resend3._domainkey.passthecert.com
```
Each should return an `amazonses.com` host.

## Step 3 — Tighten DMARC (optional but recommended)

Replace the current `v=DMARC1; p=none;` with a record that also reports back so you can monitor alignment:

| Field | Value |
|---|---|
| Type | TXT |
| Host / Name | `_dmarc` |
| Value | `v=DMARC1; p=none; rua=mailto:dmarc@passthecert.com; aspf=s; adkim=s; pct=100;` |

- `p=none` — **keep this for launch week.** Monitor before tightening.
- `rua=mailto:...` — Google sends you weekly aggregate reports. Set up a real inbox (or use `dmarc@passthecert.com` aliased to your personal email).
- After 1–2 weeks of clean reports, consider raising to `p=quarantine` (sends fail-aligned mail to spam) and eventually `p=reject`.

## Step 4 — Verify DNS propagated

Wait 5–15 min after editing DNS, then:

```bash
# SPF must return v=spf1 ...
dig +short TXT passthecert.com | grep -i 'v=spf'

# DKIM must return a CNAME to amazonses.com (one per selector)
for s in resend resend2 resend3; do
  echo "$s:"
  dig +short CNAME "$s._domainkey.passthecert.com"
done

# DMARC must return v=DMARC1 ...
dig +short TXT _dmarc.passthecert.com
```

All three queries must return values. If any is empty after 30 min, the DNS edit didn't apply — re-check the registrar.

## Step 5 — Send test emails to real inboxes

Once DNS is green, use the helper script (added in this PR):

```bash
npm run test:email -- you@gmail.com you@outlook.com you@icloud.com
```

This sends a deliverability-test email from `PassTheCert <reports@passthecert.com>` to each address and prints the Resend message ID for each one. Then **manually**:

1. Open each inbox. Confirm the email is in **Inbox**, not Spam/Junk/Promotions.
2. In Gmail, click the message → ⋮ → "Show original". Find the `Authentication-Results` header. It must show:
   - `dkim=pass`
   - `spf=pass`
   - `dmarc=pass`
3. Score the message at <https://www.mail-tester.com> — paste the address it gives you into the script. Aim for **9/10 or higher**. Anything below 7 is a launch blocker.

If any check fails, fix that DNS record before continuing — don't ship until all three pass on all three providers.

## Step 6 — Test the real diagnostic email path

Once the helper script lands cleanly, do one full end-to-end:

1. Go to `https://passthecert.com/diagnostic`
2. Complete the 10-question diagnostic with a real email address you control
3. Confirm the report email arrives in the inbox (not spam)
4. Click the upgrade link in the email — confirm it lands on `/pricing`

This is the **actual** revenue-driving email. The helper script tests deliverability of a minimal payload; the diagnostic email is heavier (HTML, links, inline styles) and may trigger different filter heuristics.

## Reusing this for future email features

When you add a new email path (welcome email post-pago D6, weekly recap, etc.):

1. **Same From domain → no DNS work.** As long as the new sender uses `@passthecert.com` (root), the SPF/DKIM/DMARC already in place cover it. Just add the new template + Resend call.
2. **Different subdomain (e.g. `welcome@send.passthecert.com`) → re-do auth at that subdomain.** Add SPF + DKIM CNAMEs at the subdomain. Don't switch to a subdomain just for vanity — it's strictly more DNS to maintain.
3. **Test the new template before shipping** — even with auth green, a heavy HTML or image-only body can trip spam filters. Run:
   ```bash
   npm run test:email -- you@gmail.com you@outlook.com
   ```
   to send a baseline. Then send the actual new template via the app to the same addresses and compare. If the new template lands in spam while the baseline doesn't, the issue is the template (links, image ratio, copy), not auth.
4. **Score new templates on mail-tester.com.** Same threshold: ≥ 9/10 to ship.
5. **Update `docs/posthog-events.md`** if the new email path emits `*_email_sent` / `*_email_failed` events so we can track deliverability per template.

## Common gotchas

- **Two SPF records → both ignored.** Vendors return SOFTFAIL. Merge into one.
- **DMARC `p=reject` too early.** If DKIM rotates and SPF was misconfigured for one day, Gmail rejects everything during that window. Stay on `p=none` for the first 2 weeks.
- **From address misalignment.** `from: reports@passthecert.com` requires SPF on `passthecert.com` (root), not on `send.passthecert.com`. If you ever switch to a subdomain, both SPF and DKIM must be re-added at that subdomain.
- **DNS TTL high (3600+).** Lower to 300 during launch week so you can iterate fast.
- **Resend "domain not verified" banner.** The dashboard shows green only when **every** required record passes. One missing CNAME = whole domain stays unverified, and Resend will silently downgrade to a shared sender.
