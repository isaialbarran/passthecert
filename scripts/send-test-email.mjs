#!/usr/bin/env node
import { Resend } from 'resend'

try {
  process.loadEnvFile('.env.local')
} catch {
  // .env.local optional — env vars may come from the shell
}

const recipients = process.argv.slice(2).filter(Boolean)

if (recipients.length === 0) {
  console.error('Usage: node scripts/send-test-email.mjs <to1> [<to2> ...]')
  console.error('Example: node scripts/send-test-email.mjs me@gmail.com me@outlook.com')
  console.error('         npm run test:email -- me@gmail.com me@outlook.com')
  process.exit(1)
}

const apiKey = process.env.RESEND_API_KEY
if (!apiKey) {
  console.error('RESEND_API_KEY missing. Set it in .env.local or export it.')
  process.exit(1)
}

const resend = new Resend(apiKey)
const FROM = 'PassTheCert <reports@passthecert.com>'
const SUBJECT = `Deliverability test — ${new Date().toISOString()}`
const HTML = `
  <div style="font-family:system-ui,-apple-system,sans-serif;max-width:560px;margin:0 auto;padding:24px;color:#1f2937">
    <h1 style="font-size:20px;margin:0 0 12px">PassTheCert deliverability check</h1>
    <p>If you're reading this in your <strong>Inbox</strong> (not Spam/Junk/Promotions), the From-domain auth is healthy.</p>
    <p>What to verify next:</p>
    <ol>
      <li>Open this email's "Show original" / "View source"</li>
      <li>Find the <code>Authentication-Results</code> header</li>
      <li>Confirm <code>dkim=pass</code>, <code>spf=pass</code>, <code>dmarc=pass</code></li>
    </ol>
    <p style="color:#6b7280;font-size:12px;margin-top:24px">
      Sent at ${new Date().toString()} — see docs/email-deliverability.md for the full runbook.
    </p>
  </div>
`

console.log(`From:    ${FROM}`)
console.log(`Subject: ${SUBJECT}`)
console.log('')

let failed = 0

for (const to of recipients) {
  process.stdout.write(`→ ${to.padEnd(40)} `)
  const { data, error } = await resend.emails.send({
    from: FROM,
    to,
    subject: SUBJECT,
    html: HTML,
  })

  if (error) {
    console.log(`FAIL — ${error.name}: ${error.message}`)
    failed++
  } else {
    console.log(`OK   — id=${data?.id}`)
  }
}

console.log('')
if (failed > 0) {
  console.error(`${failed}/${recipients.length} send failures.`)
  process.exit(1)
}
console.log(`${recipients.length}/${recipients.length} sent. Now open each inbox and verify per docs/email-deliverability.md §5.`)
