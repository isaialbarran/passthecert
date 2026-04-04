-- Domain 5.0: Security Program Management and Oversight (19 new questions)
-- Objectives: 5.1-5.6

-- ─── 5.1 Summarize elements of effective security governance ────────────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Which security document defines what employees are and are not allowed to do with company IT resources?',
  '[{"key":"A","text":"Incident response plan"},{"key":"B","text":"Acceptable use policy (AUP)"},{"key":"C","text":"Business continuity plan"},{"key":"D","text":"Service-level agreement"}]'::jsonb,
  'B',
  'An Acceptable Use Policy (AUP) defines the permitted and prohibited uses of an organization''s IT resources, including internet usage, email, software installation, and data handling. An incident response plan defines how to handle security events, a BCP ensures operations continue during disruptions, and an SLA defines service expectations between parties.',
  'easy',
  ARRAY['governance','aup','policies','obj-5.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization creates step-by-step instructions that security analysts must follow when responding to a phishing incident. What type of governance document is this?',
  '[{"key":"A","text":"Policy"},{"key":"B","text":"Standard"},{"key":"C","text":"Guideline"},{"key":"D","text":"Playbook/Procedure"}]'::jsonb,
  'D',
  'A playbook (or procedure) provides detailed, step-by-step instructions for handling specific scenarios. Policies are high-level statements of intent, standards define mandatory requirements, and guidelines are recommendations that are not mandatory. Playbooks are the most actionable and specific type of governance document.',
  'medium',
  ARRAY['governance','playbook','procedures','incident-response','obj-5.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Who in an organization is ultimately responsible for the security and proper handling of data?',
  '[{"key":"A","text":"Data custodian"},{"key":"B","text":"Data processor"},{"key":"C","text":"Data owner"},{"key":"D","text":"Data controller"}]'::jsonb,
  'C',
  'The data owner (typically a senior executive or department head) is ultimately accountable for the data''s security, classification, and proper handling. The data custodian implements the security controls on behalf of the owner, the processor handles data operationally, and the controller determines how and why data is processed (a GDPR-specific term that can overlap with owner).',
  'medium',
  ARRAY['governance','data-owner','roles','responsibilities','obj-5.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Which governance structure involves a dedicated group of senior leaders who oversee an organization''s security strategy and risk management decisions?',
  '[{"key":"A","text":"Security Operations Center (SOC)"},{"key":"B","text":"Board of directors"},{"key":"C","text":"Security steering committee"},{"key":"D","text":"Change advisory board"}]'::jsonb,
  'C',
  'A security steering committee is a cross-functional group of senior leaders responsible for overseeing security strategy, approving policies, and making risk management decisions. A SOC handles day-to-day security monitoring, the board of directors has broader business oversight, and a change advisory board reviews proposed changes to IT systems.',
  'hard',
  ARRAY['governance','committee','leadership','strategy','obj-5.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

-- ─── 5.2 Explain elements of the risk management process ───────────────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A company calculates that a specific server outage would cost $50,000 per incident and estimates it will happen twice per year. What is the Annualized Loss Expectancy (ALE)?',
  '[{"key":"A","text":"$25,000"},{"key":"B","text":"$50,000"},{"key":"C","text":"$100,000"},{"key":"D","text":"$150,000"}]'::jsonb,
  'C',
  'ALE = SLE x ARO. The Single Loss Expectancy (SLE) is $50,000 per incident, and the Annualized Rate of Occurrence (ARO) is 2. Therefore, ALE = $50,000 x 2 = $100,000 per year. This calculation helps organizations quantify risk in financial terms to make informed decisions about security investments.',
  'medium',
  ARRAY['risk-management','ale','sle','aro','quantitative','obj-5.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization decides to purchase cybersecurity insurance to cover potential losses from a data breach. Which risk management strategy is this?',
  '[{"key":"A","text":"Risk avoidance"},{"key":"B","text":"Risk mitigation"},{"key":"C","text":"Risk transference"},{"key":"D","text":"Risk acceptance"}]'::jsonb,
  'C',
  'Risk transference shifts the financial burden of a risk to a third party, typically through insurance or contractual agreements. Risk avoidance eliminates the activity causing the risk, mitigation reduces the likelihood or impact through controls, and acceptance acknowledges the risk without taking action. Insurance does not eliminate the risk itself — it transfers the financial impact.',
  'easy',
  ARRAY['risk-management','transference','insurance','obj-5.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Which risk analysis approach uses descriptive categories like "High," "Medium," and "Low" rather than numerical values to assess risk?',
  '[{"key":"A","text":"Quantitative analysis"},{"key":"B","text":"Qualitative analysis"},{"key":"C","text":"Exposure factor calculation"},{"key":"D","text":"Business impact analysis"}]'::jsonb,
  'B',
  'Qualitative risk analysis uses subjective, descriptive categories (High/Medium/Low) based on expert judgment to assess risk likelihood and impact. Quantitative analysis uses numerical values and financial calculations (SLE, ARO, ALE). Exposure factor is a percentage used in quantitative analysis, and BIA identifies critical business functions and their recovery priorities.',
  'easy',
  ARRAY['risk-management','qualitative','risk-analysis','obj-5.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

-- ─── 5.3 Explain processes associated with third-party risk assessment ──────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Before selecting a cloud provider, an organization reviews the vendor''s security certifications, financial stability, and past incident history. What is this process called?',
  '[{"key":"A","text":"Vendor monitoring"},{"key":"B","text":"Due diligence"},{"key":"C","text":"Right-to-audit"},{"key":"D","text":"Rules of engagement"}]'::jsonb,
  'B',
  'Due diligence is the thorough investigation and evaluation of a potential vendor before entering a business relationship. It includes reviewing security practices, certifications, financial health, and incident history. Vendor monitoring is ongoing oversight after selection, right-to-audit is a contractual clause allowing audits, and rules of engagement define how assessments will be conducted.',
  'easy',
  ARRAY['third-party-risk','due-diligence','vendor-assessment','obj-5.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A contract between a company and its managed service provider specifies that the service must maintain 99.9% uptime. What type of agreement is this?',
  '[{"key":"A","text":"Non-disclosure agreement (NDA)"},{"key":"B","text":"Service-level agreement (SLA)"},{"key":"C","text":"Memorandum of understanding (MOU)"},{"key":"D","text":"Business partners agreement (BPA)"}]'::jsonb,
  'B',
  'A Service-Level Agreement (SLA) defines specific, measurable performance expectations between a service provider and customer, including uptime guarantees, response times, and penalties for non-compliance. An NDA protects confidential information, an MOU is a non-binding statement of intent, and a BPA defines the relationship between business partners.',
  'easy',
  ARRAY['third-party-risk','sla','agreements','vendor-management','obj-5.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization includes a clause in its vendor contract that allows them to conduct security assessments of the vendor''s infrastructure. What is this clause called?',
  '[{"key":"A","text":"Non-compete clause"},{"key":"B","text":"Right-to-audit clause"},{"key":"C","text":"Indemnification clause"},{"key":"D","text":"Limitation of liability clause"}]'::jsonb,
  'B',
  'A right-to-audit clause gives the contracting organization the legal right to examine the vendor''s security controls, processes, and compliance status. This is essential for third-party risk management as it enables ongoing verification. Non-compete restricts business competition, indemnification addresses liability, and limitation of liability caps financial responsibility.',
  'medium',
  ARRAY['third-party-risk','right-to-audit','contracts','vendor-management','obj-5.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

-- ─── 5.4 Summarize elements of effective security compliance ────────────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A healthcare organization must protect patient records according to specific federal regulations. Which compliance framework applies?',
  '[{"key":"A","text":"PCI DSS"},{"key":"B","text":"HIPAA"},{"key":"C","text":"SOX"},{"key":"D","text":"FERPA"}]'::jsonb,
  'B',
  'HIPAA (Health Insurance Portability and Accountability Act) is a US federal regulation that protects patient health information (PHI) and sets standards for its storage, transmission, and access. PCI DSS governs payment card data, SOX applies to financial reporting for public companies, and FERPA protects student education records.',
  'easy',
  ARRAY['compliance','hipaa','healthcare','regulations','obj-5.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Under GDPR, a data subject requests that a company delete all personal data it holds about them. Which privacy right is the individual exercising?',
  '[{"key":"A","text":"Right to access"},{"key":"B","text":"Right to portability"},{"key":"C","text":"Right to be forgotten"},{"key":"D","text":"Right to restrict processing"}]'::jsonb,
  'C',
  'The right to be forgotten (right to erasure) under GDPR allows individuals to request the deletion of their personal data when it is no longer necessary for the purpose it was collected. Right to access lets individuals see what data is held, portability allows data transfer to another provider, and restriction limits how data is processed without deleting it.',
  'medium',
  ARRAY['compliance','gdpr','privacy','right-to-be-forgotten','obj-5.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization fails a compliance audit and is found to be storing payment card data without proper encryption. What is the MOST likely consequence?',
  '[{"key":"A","text":"Automatic certification renewal"},{"key":"B","text":"Fines, sanctions, and potential loss of ability to process payments"},{"key":"C","text":"Increased insurance premiums only"},{"key":"D","text":"A written warning with no further action"}]'::jsonb,
  'B',
  'Non-compliance with PCI DSS can result in significant fines from card brands, sanctions from regulatory bodies, reputational damage, and potentially losing the ability to process credit card payments entirely. The consequences of non-compliance extend beyond financial penalties to include contractual impacts and loss of business. A simple warning is unlikely for storing unencrypted card data.',
  'medium',
  ARRAY['compliance','pci-dss','non-compliance','consequences','obj-5.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

-- ─── 5.5 Explain types and purposes of audits and assessments ───────────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A penetration tester is given the network diagrams, source code, and administrator credentials before beginning the test. What type of penetration test is this?',
  '[{"key":"A","text":"Unknown environment (black box)"},{"key":"B","text":"Partially known environment (gray box)"},{"key":"C","text":"Known environment (white box)"},{"key":"D","text":"Physical penetration test"}]'::jsonb,
  'C',
  'A known environment (white box) penetration test provides the tester with full information about the target, including network diagrams, source code, and credentials. This allows for thorough testing of internal security controls. Unknown environment (black box) provides no information, partially known (gray box) provides some information, and physical tests target physical security controls.',
  'easy',
  ARRAY['audits','penetration-testing','white-box','known-environment','obj-5.5']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A pentester gathers information about a target organization using publicly available sources like LinkedIn, WHOIS, and job postings without directly interacting with the target''s systems. What type of reconnaissance is this?',
  '[{"key":"A","text":"Active reconnaissance"},{"key":"B","text":"Passive reconnaissance"},{"key":"C","text":"Vulnerability scanning"},{"key":"D","text":"Social engineering"}]'::jsonb,
  'B',
  'Passive reconnaissance gathers information from publicly available sources (OSINT) without directly interacting with the target''s systems — no packets are sent to the target. Active reconnaissance directly probes the target (port scanning, network mapping). Vulnerability scanning is automated active testing, and social engineering manipulates people.',
  'medium',
  ARRAY['audits','reconnaissance','passive','osint','obj-5.5']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization hires an independent firm to evaluate the effectiveness of its security controls and compliance with industry regulations. What type of audit is this?',
  '[{"key":"A","text":"Internal audit"},{"key":"B","text":"Self-assessment"},{"key":"C","text":"Independent third-party audit"},{"key":"D","text":"Regulatory examination"}]'::jsonb,
  'C',
  'An independent third-party audit is conducted by an external firm with no organizational ties, providing an objective evaluation of security controls and compliance. Internal audits are performed by the organization''s own staff, self-assessments are informal internal evaluations, and regulatory examinations are conducted by government agencies or regulatory bodies.',
  'easy',
  ARRAY['audits','third-party-audit','compliance','assessment','obj-5.5']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

-- ─── 5.6 Given a scenario, implement security awareness practices ───────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization sends simulated phishing emails to employees and tracks who clicks the links. What is the PRIMARY purpose of this exercise?',
  '[{"key":"A","text":"To punish employees who fail"},{"key":"B","text":"To identify vulnerabilities in the email server"},{"key":"C","text":"To measure security awareness and identify training needs"},{"key":"D","text":"To test the incident response team"}]'::jsonb,
  'C',
  'Phishing simulation campaigns measure employee security awareness levels and identify individuals or departments that need additional training. The goal is educational, not punitive — understanding where weaknesses exist allows targeted training. It does not test the email server''s security or the incident response team''s capabilities.',
  'easy',
  ARRAY['security-awareness','phishing-campaign','training','obj-5.6']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An employee receives an email from the CEO requesting an urgent wire transfer. The email address looks correct but was actually spoofed. Which security awareness topic is MOST relevant?',
  '[{"key":"A","text":"Password management"},{"key":"B","text":"Removable media policies"},{"key":"C","text":"Social engineering and business email compromise"},{"key":"D","text":"Physical security awareness"}]'::jsonb,
  'C',
  'Business Email Compromise (BEC) is a form of social engineering where attackers impersonate executives or trusted parties to trick employees into transferring money or sharing sensitive information. Security awareness training should teach employees to verify unusual requests through a separate communication channel. Password management, removable media, and physical security are different awareness domains.',
  'medium',
  ARRAY['security-awareness','bec','social-engineering','training','obj-5.6']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A remote employee connects to a coffee shop''s public Wi-Fi to access company resources without using the corporate VPN. Which security awareness topic should be reinforced?',
  '[{"key":"A","text":"Insider threat awareness"},{"key":"B","text":"Operational security in hybrid/remote work environments"},{"key":"C","text":"Password complexity requirements"},{"key":"D","text":"Data classification procedures"}]'::jsonb,
  'B',
  'Operational security in hybrid and remote work environments teaches employees about the risks of public Wi-Fi, the importance of VPN usage, physical security of devices, and secure handling of sensitive information outside the office. Insider threat awareness covers malicious employees, password complexity addresses credential strength, and data classification covers labeling data.',
  'medium',
  ARRAY['security-awareness','remote-work','opsec','training','obj-5.6']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';
