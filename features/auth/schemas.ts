import { z } from 'zod'

const toStr = z.preprocess((val) => (typeof val === 'string' ? val.trim() : ''), z.string())

export const signUpSchema = z.object({
  email: toStr.pipe(z.string().min(1, 'Email is required').email('Please enter a valid email address')),
  password: toStr.pipe(z.string().min(8, 'Password must be at least 8 characters')),
})

export const signInSchema = z.object({
  email: toStr.pipe(z.string().min(1, 'Email is required').email('Please enter a valid email address')),
  password: toStr.pipe(z.string().min(1, 'Password is required')),
})

export const forgotPasswordSchema = z.object({
  email: toStr.pipe(z.string().min(1, 'Email is required').email('Please enter a valid email address')),
})

export const resetPasswordSchema = z.object({
  password: toStr.pipe(z.string().min(8, 'Password must be at least 8 characters')),
})

export type SignUpInput = z.infer<typeof signUpSchema>
export type SignInInput = z.infer<typeof signInSchema>
export type ForgotPasswordInput = z.infer<typeof forgotPasswordSchema>
export type ResetPasswordInput = z.infer<typeof resetPasswordSchema>
