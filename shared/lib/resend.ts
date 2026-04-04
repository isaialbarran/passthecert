import { Resend } from 'resend'
import { serverEnv } from './env'

let _resend: Resend | null = null

export function resend(): Resend {
  if (!_resend) {
    _resend = new Resend(serverEnv().RESEND_API_KEY)
  }
  return _resend
}
