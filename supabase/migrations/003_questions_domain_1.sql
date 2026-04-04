-- Domain 1.0: General Security Concepts (11 new questions)
-- Objectives: 1.1 (Security controls), 1.2 (Fundamental concepts), 1.3 (Change management), 1.4 (Cryptography)

-- Ensure exam and domain rows exist before question inserts (migrations run before seed.sql)
INSERT INTO public.exams (slug, name, vendor, total_questions, pass_score, duration_mins)
VALUES ('comptia-security-plus', 'CompTIA Security+ (SY0-701)', 'CompTIA', 90, 750, 90)
ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.domains (exam_id, name, code, weight_pct)
SELECT e.id, 'General Security Concepts', '1.0', 12 FROM public.exams e
WHERE e.slug = 'comptia-security-plus'
AND NOT EXISTS (SELECT 1 FROM public.domains WHERE exam_id = e.id AND code = '1.0');

INSERT INTO public.domains (exam_id, name, code, weight_pct)
SELECT e.id, 'Threats, Vulnerabilities, and Mitigations', '2.0', 22 FROM public.exams e
WHERE e.slug = 'comptia-security-plus'
AND NOT EXISTS (SELECT 1 FROM public.domains WHERE exam_id = e.id AND code = '2.0');

INSERT INTO public.domains (exam_id, name, code, weight_pct)
SELECT e.id, 'Security Architecture', '3.0', 18 FROM public.exams e
WHERE e.slug = 'comptia-security-plus'
AND NOT EXISTS (SELECT 1 FROM public.domains WHERE exam_id = e.id AND code = '3.0');

INSERT INTO public.domains (exam_id, name, code, weight_pct)
SELECT e.id, 'Security Operations', '4.0', 28 FROM public.exams e
WHERE e.slug = 'comptia-security-plus'
AND NOT EXISTS (SELECT 1 FROM public.domains WHERE exam_id = e.id AND code = '4.0');

INSERT INTO public.domains (exam_id, name, code, weight_pct)
SELECT e.id, 'Security Program Management and Oversight', '5.0', 20 FROM public.exams e
WHERE e.slug = 'comptia-security-plus'
AND NOT EXISTS (SELECT 1 FROM public.domains WHERE exam_id = e.id AND code = '5.0');

-- ─── 1.1 Compare and contrast various types of security controls ─────────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A company installs security cameras throughout its office building to discourage theft. Which type of security control is this?',
  '[{"key":"A","text":"Detective"},{"key":"B","text":"Corrective"},{"key":"C","text":"Deterrent"},{"key":"D","text":"Compensating"}]'::jsonb,
  'C',
  'Security cameras serve as a deterrent control because their visible presence discourages potential wrongdoers from attempting theft or unauthorized actions. A detective control identifies incidents after they occur (like reviewing camera footage), a corrective control fixes issues after detection, and a compensating control is an alternative when a primary control is not feasible.',
  'easy',
  ARRAY['security-controls','deterrent','physical-security','obj-1.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization implements a firewall rule that blocks all inbound traffic on unused ports. Which control category and type does this BEST represent?',
  '[{"key":"A","text":"Operational / Detective"},{"key":"B","text":"Technical / Preventive"},{"key":"C","text":"Managerial / Directive"},{"key":"D","text":"Physical / Compensating"}]'::jsonb,
  'B',
  'A firewall rule is a technical (logical) control because it is implemented through technology, and it is preventive because it blocks unauthorized traffic before it can reach the network. Operational controls are implemented by people (like security guards), managerial controls are policies and procedures, and physical controls protect tangible assets.',
  'medium',
  ARRAY['security-controls','firewall','preventive','obj-1.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'After a security breach, an organization activates its incident response plan and restores affected systems from backups. Which type of security control is being applied?',
  '[{"key":"A","text":"Preventive"},{"key":"B","text":"Deterrent"},{"key":"C","text":"Corrective"},{"key":"D","text":"Directive"}]'::jsonb,
  'C',
  'Restoring systems from backups after a breach is a corrective control — it remediates or fixes the damage caused by a security incident. Preventive controls stop incidents before they happen, deterrent controls discourage attacks, and directive controls provide guidance through policies or instructions.',
  'easy',
  ARRAY['security-controls','corrective','incident-response','obj-1.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';

-- ─── 1.2 Summarize fundamental security concepts ────────────────────────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'In a Zero Trust architecture, which component is responsible for making the final decision on whether to grant or deny access to a resource?',
  '[{"key":"A","text":"Policy Enforcement Point"},{"key":"B","text":"Policy Engine"},{"key":"C","text":"Policy Administrator"},{"key":"D","text":"Implicit Trust Zone"}]'::jsonb,
  'B',
  'The Policy Engine is the brain of Zero Trust — it evaluates access requests against defined policies and makes the grant/deny decision. The Policy Administrator communicates that decision and configures the data path, while the Policy Enforcement Point actually enforces the decision by allowing or blocking traffic. Implicit trust zones are the opposite of Zero Trust — they assume trust within a network segment.',
  'hard',
  ARRAY['zero-trust','policy-engine','access-control','obj-1.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security team deploys a fake database server containing fictitious customer records to detect and study attackers who gain network access. What is this technique called?',
  '[{"key":"A","text":"Honeynet"},{"key":"B","text":"Honeypot"},{"key":"C","text":"Honeyfile"},{"key":"D","text":"Honeytoken"}]'::jsonb,
  'B',
  'A honeypot is a decoy system designed to lure attackers and study their behavior. It mimics a real server (in this case, a database) to detect unauthorized access. A honeynet is a network of honeypots, a honeyfile is a fake document placed to detect unauthorized access, and a honeytoken is a piece of fake data (like credentials) that triggers an alert when used.',
  'medium',
  ARRAY['deception','honeypot','threat-detection','obj-1.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization performs an analysis to identify the differences between its current security posture and the desired state defined by industry standards. What is this process called?',
  '[{"key":"A","text":"Risk assessment"},{"key":"B","text":"Vulnerability scan"},{"key":"C","text":"Gap analysis"},{"key":"D","text":"Penetration test"}]'::jsonb,
  'C',
  'A gap analysis compares the current state of security controls against a desired framework or standard to identify deficiencies (gaps) that need to be addressed. A risk assessment evaluates threats and their potential impact, a vulnerability scan identifies technical weaknesses in systems, and a penetration test actively exploits vulnerabilities to test defenses.',
  'medium',
  ARRAY['gap-analysis','security-assessment','governance','obj-1.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';

-- ─── 1.3 Explain importance of change management processes ──────────────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Before deploying a critical software update to production, the IT team documents a plan to revert to the previous version if the update causes issues. What is this plan called?',
  '[{"key":"A","text":"Impact analysis"},{"key":"B","text":"Backout plan"},{"key":"C","text":"Standard operating procedure"},{"key":"D","text":"Maintenance window"}]'::jsonb,
  'B',
  'A backout plan (also called a rollback plan) documents the steps needed to reverse a change and return to the previous state if the change fails or causes problems. An impact analysis assesses potential effects before making a change, an SOP is a routine procedure document, and a maintenance window is the scheduled time when changes are allowed.',
  'easy',
  ARRAY['change-management','backout-plan','operations','obj-1.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A system administrator needs to update a legacy application that several other services depend on. Which change management consideration should be evaluated FIRST?',
  '[{"key":"A","text":"Maintenance window scheduling"},{"key":"B","text":"Dependencies"},{"key":"C","text":"Version control"},{"key":"D","text":"Backout plan"}]'::jsonb,
  'B',
  'Dependencies must be evaluated first because changes to a legacy application that other services rely on can cascade failures throughout the environment. Understanding what depends on the application determines the scope of impact and informs all subsequent decisions: when to schedule the window, what to include in the backout plan, and how to manage version control.',
  'hard',
  ARRAY['change-management','dependencies','legacy-applications','obj-1.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A company is preparing to deploy a major software update. The change management team requires updating network diagrams and security policies to reflect the new system. Which change management element does this represent?',
  '[{"key":"A","text":"Backout plan"},{"key":"B","text":"Impact analysis"},{"key":"C","text":"Documentation updates"},{"key":"D","text":"Maintenance window"}]'::jsonb,
  'C',
  'Documentation updates are a critical part of change management — whenever a system changes, all related documentation (network diagrams, policies, procedures, configuration records) must be updated to reflect the current state. A backout plan reverses failed changes, impact analysis evaluates potential effects before changes, and a maintenance window is the scheduled time for changes.',
  'medium',
  ARRAY['change-management','documentation','version-control','obj-1.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';

-- ─── 1.4 Explain importance of using appropriate cryptographic solutions ─────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization needs to verify that a software update has not been tampered with during download. Which cryptographic technique should they use?',
  '[{"key":"A","text":"Symmetric encryption"},{"key":"B","text":"Hashing"},{"key":"C","text":"Steganography"},{"key":"D","text":"Tokenization"}]'::jsonb,
  'B',
  'Hashing produces a fixed-length digest (fingerprint) of data that changes if even one bit is modified. By comparing the hash of the downloaded file against the published hash, the organization can verify the file''s integrity. Symmetric encryption protects confidentiality, steganography hides data within other data, and tokenization replaces sensitive data with non-sensitive placeholders.',
  'easy',
  ARRAY['cryptography','hashing','integrity','obj-1.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A company wants to protect credit card numbers stored in its database by replacing them with random values that map back to the originals through a secure vault. Which technique is this?',
  '[{"key":"A","text":"Data masking"},{"key":"B","text":"Encryption"},{"key":"C","text":"Tokenization"},{"key":"D","text":"Steganography"}]'::jsonb,
  'C',
  'Tokenization replaces sensitive data (like credit card numbers) with non-sensitive tokens that have no exploitable value on their own. The original data is stored in a secure token vault and can only be retrieved through the tokenization system. Data masking obscures data but is typically irreversible, encryption transforms data using an algorithm and key, and steganography hides data within other files.',
  'medium',
  ARRAY['cryptography','tokenization','data-protection','obj-1.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';
