-- supabase/seed.sql
-- Run after migrations

-- Insert exam
insert into public.exams (slug, name, vendor, total_questions, pass_score, duration_mins)
values ('comptia-security-plus', 'CompTIA Security+ (SY0-701)', 'CompTIA', 90, 750, 90);

-- Insert domains (Security+ SY0-701 official domains)
insert into public.domains (exam_id, name, code, weight_pct)
select id, 'General Security Concepts', '1.0', 12 from public.exams where slug = 'comptia-security-plus'
union all
select id, 'Threats, Vulnerabilities, and Mitigations', '2.0', 22 from public.exams where slug = 'comptia-security-plus'
union all
select id, 'Security Architecture', '3.0', 18 from public.exams where slug = 'comptia-security-plus'
union all
select id, 'Security Operations', '4.0', 28 from public.exams where slug = 'comptia-security-plus'
union all
select id, 'Security Program Management and Oversight', '5.0', 20 from public.exams where slug = 'comptia-security-plus';

-- Insert sample questions (expand to 100+ before launch)
insert into public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
select
  e.id,
  d.id,
  'A security analyst discovers that an attacker has been intercepting traffic between a client and server without either party being aware. Which type of attack is this?',
  '[{"key":"A","text":"SQL Injection"},{"key":"B","text":"Man-in-the-Middle (MitM)"},{"key":"C","text":"Denial of Service"},{"key":"D","text":"Phishing"}]'::jsonb,
  'B',
  'A Man-in-the-Middle (MitM) attack occurs when an attacker secretly relays and possibly alters communications between two parties who believe they are communicating directly with each other. SQL Injection targets databases, DoS disrupts availability, and phishing targets users through deception.',
  'easy',
  array['network-security','attacks','mitm']
from public.exams e, public.domains d
where e.slug = 'comptia-security-plus' and d.code = '2.0'

union all

select
  e.id,
  d.id,
  'Which cryptographic concept ensures that a sender cannot deny having sent a message?',
  '[{"key":"A","text":"Confidentiality"},{"key":"B","text":"Integrity"},{"key":"C","text":"Non-repudiation"},{"key":"D","text":"Availability"}]'::jsonb,
  'C',
  'Non-repudiation ensures that a party cannot deny the authenticity of their signature on a document or a message they sent. This is typically achieved through digital signatures using asymmetric cryptography. Confidentiality protects data from unauthorized access, integrity ensures data has not been altered, and availability ensures systems are accessible.',
  'medium',
  array['cryptography','pki','digital-signatures']
from public.exams e, public.domains d
where e.slug = 'comptia-security-plus' and d.code = '1.0'

union all

select
  e.id,
  d.id,
  'An organization wants to ensure that only authorized devices can connect to their corporate network. Which technology should they implement?',
  '[{"key":"A","text":"VPN"},{"key":"B","text":"NAC (Network Access Control)"},{"key":"C","text":"IDS"},{"key":"D","text":"DLP"}]'::jsonb,
  'B',
  'Network Access Control (NAC) enforces security policy compliance on devices before granting network access. It can verify device health, patch levels, and identity before allowing connection. VPNs encrypt remote connections, IDS detects intrusions, and DLP prevents data exfiltration.',
  'medium',
  array['network-security','access-control','nac']
from public.exams e, public.domains d
where e.slug = 'comptia-security-plus' and d.code = '3.0'

union all

select
  e.id,
  d.id,
  'What is the PRIMARY purpose of a Security Information and Event Management (SIEM) system?',
  '[{"key":"A","text":"To encrypt data at rest"},{"key":"B","text":"To collect, correlate, and analyze security logs from multiple sources"},{"key":"C","text":"To block malicious network traffic in real time"},{"key":"D","text":"To manage user passwords and access rights"}]'::jsonb,
  'B',
  'A SIEM system aggregates and correlates log data from multiple sources (firewalls, servers, applications) to provide real-time analysis of security alerts. It helps security teams detect threats, investigate incidents, and meet compliance requirements. It does not encrypt data, block traffic directly (that''s a firewall/IPS), or manage passwords (that''s an IAM system).',
  'easy',
  array['siem','monitoring','security-operations']
from public.exams e, public.domains d
where e.slug = 'comptia-security-plus' and d.code = '4.0'

union all

select
  e.id,
  d.id,
  'A company''s security policy requires that users change their passwords every 90 days and cannot reuse their last 10 passwords. Which security concept does this BEST represent?',
  '[{"key":"A","text":"Account lockout policy"},{"key":"B","text":"Least privilege"},{"key":"C","text":"Password complexity requirements"},{"key":"D","text":"Password history and expiration policy"}]'::jsonb,
  'D',
  'Password history and expiration policies enforce regular password changes (expiration) and prevent reuse of recent passwords (history). Account lockout triggers after failed attempts, least privilege limits user permissions to the minimum necessary, and complexity requirements enforce character rules (uppercase, numbers, symbols).',
  'easy',
  array['identity-management','password-policy','access-control']
from public.exams e, public.domains d
where e.slug = 'comptia-security-plus' and d.code = '5.0';
