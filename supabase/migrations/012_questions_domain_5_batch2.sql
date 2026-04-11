-- Domain 5.0: Security Program Management and Oversight — Batch 2 (37 questions)
-- Objectives: 5.1-5.6
-- Topics: DPO, NIST CSF, SOC 2/ISO 27001, risk register, inherent/residual risk, CCPA, mandatory vacation

-- ─── 5.1 Elements of effective security governance ─────────────────────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization''s board issues a high-level statement requiring all customer data to be encrypted. Department managers then create specific rules for how encryption must be implemented. What is the correct hierarchy?',
  '[{"key":"A","text":"Standard → Policy → Guideline"},{"key":"B","text":"Policy → Standard → Procedure"},{"key":"C","text":"Guideline → Policy → Standard"},{"key":"D","text":"Procedure → Standard → Policy"}]'::jsonb,
  'B',
  'The governance hierarchy flows from Policy (high-level intent, e.g., "all data must be encrypted") to Standard (specific mandatory requirements, e.g., "use AES-256") to Procedure (step-by-step instructions for implementation). Guidelines are recommendations, not mandatory. This hierarchy ensures alignment from strategic intent to operational execution.',
  'medium',
  ARRAY['governance','policy-hierarchy','standards','obj-5.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Under GDPR, an organization that processes personal data of EU residents at scale must appoint a specific role to oversee data protection compliance. What is this role?',
  '[{"key":"A","text":"Chief Information Security Officer"},{"key":"B","text":"Data Privacy Officer (DPO)"},{"key":"C","text":"Data Custodian"},{"key":"D","text":"Compliance Auditor"}]'::jsonb,
  'B',
  'The Data Privacy Officer (DPO) is a role required by GDPR for organizations that process personal data at scale. The DPO oversees data protection strategy, ensures compliance, and serves as the contact point for data subjects and regulators. The CISO manages overall security, the data custodian implements controls, and auditors evaluate compliance.',
  'medium',
  ARRAY['governance','dpo','gdpr','privacy','obj-5.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization requires that no single employee can both approve and process financial transactions. Which governance principle does this enforce?',
  '[{"key":"A","text":"Least privilege"},{"key":"B","text":"Separation of duties"},{"key":"C","text":"Job rotation"},{"key":"D","text":"Mandatory vacation"}]'::jsonb,
  'B',
  'Separation of duties divides critical tasks among multiple people so that no single person can complete a high-risk action alone, preventing fraud and errors. Least privilege limits permissions to the minimum needed, job rotation moves employees between roles periodically, and mandatory vacation forces time away to detect irregularities.',
  'easy',
  ARRAY['governance','separation-of-duties','internal-controls','obj-5.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A company requires all employees in finance to take at least one continuous week of vacation per year. What is the PRIMARY security purpose of this policy?',
  '[{"key":"A","text":"To improve employee morale"},{"key":"B","text":"To detect fraud or policy violations that the employee may be concealing"},{"key":"C","text":"To reduce overtime costs"},{"key":"D","text":"To test the business continuity plan"}]'::jsonb,
  'B',
  'Mandatory vacation policies force employees away from their duties, allowing others to perform their role and potentially uncover fraudulent activities, policy violations, or irregularities that the employee was hiding through continuous presence. While morale and BCP testing are side benefits, fraud detection is the primary security purpose.',
  'medium',
  ARRAY['governance','mandatory-vacation','fraud-detection','internal-controls','obj-5.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization periodically moves employees between different roles within the IT department. Which security benefit does this PRIMARILY provide?',
  '[{"key":"A","text":"Reduces training costs"},{"key":"B","text":"Prevents knowledge silos and detects potential abuse of access"},{"key":"C","text":"Increases employee satisfaction"},{"key":"D","text":"Reduces the need for background checks"}]'::jsonb,
  'B',
  'Job rotation moves employees between positions, reducing the risk of fraud by limiting how long one person controls a function, breaking up collusion opportunities, and ensuring multiple people understand each role. Reducing knowledge silos also improves resilience. Training costs may increase, and satisfaction varies by individual.',
  'medium',
  ARRAY['governance','job-rotation','internal-controls','obj-5.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization creates and maintains a catalog of all personal data it collects, including where it is stored, who has access, and how long it is retained. What is this process called?',
  '[{"key":"A","text":"Data classification"},{"key":"B","text":"Data inventory and mapping"},{"key":"C","text":"Data masking"},{"key":"D","text":"Data loss prevention"}]'::jsonb,
  'B',
  'Data inventory and mapping creates a comprehensive record of all personal data across the organization — what data exists, where it''s stored, who accesses it, and retention periods. This is essential for privacy compliance (GDPR, CCPA). Data classification categorizes by sensitivity, masking obscures data, and DLP prevents unauthorized transmission.',
  'medium',
  ARRAY['governance','data-inventory','data-mapping','privacy','obj-5.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A company''s data retention policy specifies that employee records must be kept for 7 years after termination, then securely destroyed. What does this policy ensure?',
  '[{"key":"A","text":"Maximum data availability for analytics"},{"key":"B","text":"Compliance with legal requirements while minimizing data exposure"},{"key":"C","text":"Unlimited data storage capacity"},{"key":"D","text":"Faster database query performance"}]'::jsonb,
  'B',
  'Data retention policies balance legal/regulatory requirements to keep data for specified periods with the security principle of minimizing stored data to reduce exposure risk. After the retention period, secure destruction reduces the attack surface. It''s not about maximizing availability, storage capacity, or performance.',
  'easy',
  ARRAY['governance','data-retention','destruction','compliance','obj-5.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'The NIST Cybersecurity Framework organizes security activities into five core functions. Which list correctly identifies all five?',
  '[{"key":"A","text":"Authenticate, Authorize, Audit, Alert, Act"},{"key":"B","text":"Identify, Protect, Detect, Respond, Recover"},{"key":"C","text":"Plan, Implement, Monitor, Review, Improve"},{"key":"D","text":"Assess, Mitigate, Transfer, Accept, Avoid"}]'::jsonb,
  'B',
  'The NIST CSF five core functions are Identify (asset management, risk assessment), Protect (access control, training), Detect (monitoring, anomalies), Respond (incident response, communications), and Recover (recovery planning, improvements). The other options mix various frameworks and concepts but are not the NIST CSF functions.',
  'easy',
  ARRAY['governance','nist-csf','framework','obj-5.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization is selecting a security framework. They need international recognition and formal certification to demonstrate security maturity to global clients. Which framework is MOST appropriate?',
  '[{"key":"A","text":"NIST CSF"},{"key":"B","text":"ISO 27001"},{"key":"C","text":"CIS Controls"},{"key":"D","text":"COBIT"}]'::jsonb,
  'B',
  'ISO 27001 is an international standard that provides formal certification through accredited auditors, making it ideal for demonstrating security maturity to global clients. NIST CSF is widely used in the US but doesn''t offer certification, CIS Controls are technical baselines, and COBIT focuses on IT governance rather than security certification.',
  'hard',
  ARRAY['governance','iso-27001','certification','frameworks','obj-5.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A SaaS company needs to demonstrate to customers that it has effective controls over security, availability, and confidentiality. Which audit report should they obtain?',
  '[{"key":"A","text":"PCI DSS certification"},{"key":"B","text":"SOC 2 Type II report"},{"key":"C","text":"HIPAA compliance letter"},{"key":"D","text":"FISMA authorization"}]'::jsonb,
  'B',
  'A SOC 2 Type II report evaluates an organization''s controls over security, availability, processing integrity, confidentiality, and privacy over a period of time. It is the industry standard for SaaS providers demonstrating trust. PCI DSS is for payment card data, HIPAA for healthcare, and FISMA for US federal agencies.',
  'hard',
  ARRAY['governance','soc2','audit','trust','obj-5.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

-- ─── 5.2 Risk management process ──────────────────────────────────────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security team maintains a document listing all identified risks, their likelihood, impact, assigned owners, and current mitigation status. What is this document?',
  '[{"key":"A","text":"Incident response plan"},{"key":"B","text":"Risk register"},{"key":"C","text":"Vulnerability report"},{"key":"D","text":"Business continuity plan"}]'::jsonb,
  'B',
  'A risk register is a centralized document that records identified risks along with their likelihood, impact, risk owner, mitigation strategies, and current status. It serves as the primary tool for ongoing risk management. An incident response plan handles security events, vulnerability reports list technical findings, and a BCP addresses operational continuity.',
  'easy',
  ARRAY['risk-management','risk-register','documentation','obj-5.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A risk assessment identifies a threat with high likelihood and high impact. After implementing security controls, the remaining risk is reduced to medium likelihood and low impact. What is the remaining risk called?',
  '[{"key":"A","text":"Inherent risk"},{"key":"B","text":"Residual risk"},{"key":"C","text":"Risk appetite"},{"key":"D","text":"Control risk"}]'::jsonb,
  'B',
  'Residual risk is the risk that remains after security controls have been applied. Inherent risk is the original risk level before any controls, risk appetite is the amount of risk an organization is willing to accept, and control risk is the risk that controls themselves may fail or be insufficient.',
  'medium',
  ARRAY['risk-management','residual-risk','inherent-risk','obj-5.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization''s leadership states: "We are willing to accept a moderate level of cybersecurity risk in exchange for faster time-to-market on new products." What does this statement define?',
  '[{"key":"A","text":"Risk tolerance"},{"key":"B","text":"Risk appetite"},{"key":"C","text":"Risk threshold"},{"key":"D","text":"Risk avoidance"}]'::jsonb,
  'B',
  'Risk appetite is the overall amount and type of risk an organization is willing to accept in pursuit of its objectives — a strategic-level statement. Risk tolerance is the acceptable variation from the appetite for specific risks, risk threshold is the specific point at which risk becomes unacceptable, and risk avoidance eliminates the risk entirely.',
  'hard',
  ARRAY['risk-management','risk-appetite','strategy','obj-5.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'What is the difference between risk appetite and risk tolerance?',
  '[{"key":"A","text":"Risk appetite is tactical; risk tolerance is strategic"},{"key":"B","text":"Risk appetite is the overall willingness to accept risk; risk tolerance is the acceptable variation for specific risks"},{"key":"C","text":"They are identical concepts with different names"},{"key":"D","text":"Risk tolerance applies only to financial risks; risk appetite applies to all risks"}]'::jsonb,
  'B',
  'Risk appetite is the broad, strategic level of risk an organization is willing to accept. Risk tolerance is the specific, measurable deviation acceptable for individual risks or categories. For example, appetite might be "moderate risk acceptable" while tolerance for a specific system might be "99.9% uptime minimum." They are related but distinct concepts.',
  'hard',
  ARRAY['risk-management','risk-appetite','risk-tolerance','obj-5.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A risk matrix plots likelihood on one axis and impact on the other. A risk in the upper-right quadrant represents which combination?',
  '[{"key":"A","text":"Low likelihood, low impact"},{"key":"B","text":"High likelihood, high impact"},{"key":"C","text":"Low likelihood, high impact"},{"key":"D","text":"High likelihood, low impact"}]'::jsonb,
  'B',
  'In a standard risk matrix, the upper-right quadrant represents high likelihood and high impact — the highest priority risks requiring immediate attention. Lower-left is low/low (accept), upper-left and lower-right are mixed priority. Risk matrices are visual tools for prioritizing risk response.',
  'easy',
  ARRAY['risk-management','risk-matrix','assessment','obj-5.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization tracks metrics such as the number of unpatched critical vulnerabilities, average time to detect incidents, and percentage of employees who fail phishing tests. What are these metrics called?',
  '[{"key":"A","text":"Key Performance Indicators (KPIs)"},{"key":"B","text":"Key Risk Indicators (KRIs)"},{"key":"C","text":"Service Level Objectives (SLOs)"},{"key":"D","text":"Control objectives"}]'::jsonb,
  'B',
  'Key Risk Indicators (KRIs) are metrics that provide early warning signals about increasing risk levels. Unpatched vulnerabilities, detection time, and phishing failure rates all indicate rising security risk. KPIs measure performance toward goals, SLOs define target service levels, and control objectives are desired outcomes of security controls.',
  'hard',
  ARRAY['risk-management','kri','metrics','monitoring','obj-5.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Before deploying a new customer data processing system, the organization evaluates how the system will affect individual privacy rights. What is this assessment called?',
  '[{"key":"A","text":"Risk assessment"},{"key":"B","text":"Vulnerability assessment"},{"key":"C","text":"Privacy Impact Assessment (PIA)"},{"key":"D","text":"Business Impact Analysis"}]'::jsonb,
  'C',
  'A Privacy Impact Assessment (PIA) evaluates how a system or process collects, uses, stores, and shares personal data, identifying privacy risks and ensuring compliance with privacy regulations. A risk assessment evaluates broader security risks, a vulnerability assessment identifies technical weaknesses, and a BIA identifies critical business functions.',
  'medium',
  ARRAY['risk-management','pia','privacy','assessment','obj-5.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

-- ─── 5.3 Third-party risk assessment ──────────────────────────────────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'After onboarding a new cloud vendor, an organization continuously reviews the vendor''s security posture, incident reports, and compliance certifications on an annual basis. What is this called?',
  '[{"key":"A","text":"Due diligence"},{"key":"B","text":"Vendor monitoring"},{"key":"C","text":"Rules of engagement"},{"key":"D","text":"Attestation"}]'::jsonb,
  'B',
  'Vendor monitoring is the ongoing oversight of a third party''s security posture after the initial selection (due diligence). It includes reviewing compliance reports, monitoring for incidents, and reassessing risk periodically. Due diligence is the initial evaluation, rules of engagement define assessment boundaries, and attestation is a formal statement of compliance.',
  'medium',
  ARRAY['third-party-risk','vendor-monitoring','ongoing','obj-5.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A contract between a company and a vendor defines the overall relationship, payment terms, intellectual property rights, and termination conditions. What type of agreement is this?',
  '[{"key":"A","text":"SLA"},{"key":"B","text":"NDA"},{"key":"C","text":"MSA (Master Service Agreement)"},{"key":"D","text":"MOU"}]'::jsonb,
  'C',
  'A Master Service Agreement (MSA) establishes the overarching terms of the business relationship between parties, including payment, IP, liability, and termination. SLAs define specific performance metrics, NDAs protect confidential information, and MOUs express mutual intent without binding commitments.',
  'medium',
  ARRAY['third-party-risk','msa','agreements','vendor-management','obj-5.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A company discovers that a software library used by one of its vendors was compromised, potentially affecting all downstream customers. What type of risk does this represent?',
  '[{"key":"A","text":"Insider threat"},{"key":"B","text":"Supply chain risk"},{"key":"C","text":"Natural disaster risk"},{"key":"D","text":"Reputational risk"}]'::jsonb,
  'B',
  'Supply chain risk arises when a vendor, supplier, or their dependencies are compromised, potentially affecting all downstream organizations. A compromised library in the supply chain can propagate vulnerabilities to many customers. Insider threats come from within, natural disasters are environmental, and reputational risk is the consequence — not the threat type.',
  'easy',
  ARRAY['third-party-risk','supply-chain','vendor-risk','obj-5.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A document appended to an MSA specifies the exact deliverables, timelines, and acceptance criteria for a particular project with a vendor. What is this document?',
  '[{"key":"A","text":"Non-disclosure agreement"},{"key":"B","text":"Statement of Work (SOW)"},{"key":"C","text":"Business Partners Agreement"},{"key":"D","text":"Acceptable use policy"}]'::jsonb,
  'B',
  'A Statement of Work (SOW) defines specific deliverables, tasks, timelines, and acceptance criteria for a particular project or engagement under the broader MSA. An NDA protects confidential information, a BPA defines partnership terms, and an AUP governs IT resource usage.',
  'medium',
  ARRAY['third-party-risk','sow','agreements','vendor-management','obj-5.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

-- ─── 5.4 Security compliance ──────────────────────────────────────────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A California-based company must allow consumers to know what personal data is collected, request its deletion, and opt out of its sale. Which regulation requires this?',
  '[{"key":"A","text":"GDPR"},{"key":"B","text":"HIPAA"},{"key":"C","text":"CCPA"},{"key":"D","text":"FERPA"}]'::jsonb,
  'C',
  'The California Consumer Privacy Act (CCPA) gives California consumers the right to know what personal data is collected, request deletion, and opt out of data sales. GDPR applies to EU residents, HIPAA protects health information, and FERPA protects student education records.',
  'easy',
  ARRAY['compliance','ccpa','privacy','california','obj-5.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A publicly traded company must ensure the accuracy and integrity of its financial reporting systems and implement internal controls. Which regulation mandates this?',
  '[{"key":"A","text":"HIPAA"},{"key":"B","text":"PCI DSS"},{"key":"C","text":"SOX"},{"key":"D","text":"GDPR"}]'::jsonb,
  'C',
  'The Sarbanes-Oxley Act (SOX) requires publicly traded companies to maintain accurate financial records and implement internal controls to prevent fraud. HIPAA protects health information, PCI DSS secures payment card data, and GDPR protects EU personal data.',
  'easy',
  ARRAY['compliance','sox','financial','regulations','obj-5.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A university must protect student education records and cannot disclose them without the student''s consent. Which regulation applies?',
  '[{"key":"A","text":"GDPR"},{"key":"B","text":"FERPA"},{"key":"C","text":"CCPA"},{"key":"D","text":"HIPAA"}]'::jsonb,
  'B',
  'The Family Educational Rights and Privacy Act (FERPA) protects student education records and prohibits disclosure without consent. GDPR covers EU residents'' personal data, CCPA applies to California consumers, and HIPAA protects healthcare information.',
  'easy',
  ARRAY['compliance','ferpa','education','privacy','obj-5.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An EU-based company needs to transfer personal data to a US-based processor. Which mechanism can they use to ensure GDPR compliance for this transfer?',
  '[{"key":"A","text":"Acceptable use policy"},{"key":"B","text":"Standard Contractual Clauses (SCCs)"},{"key":"C","text":"Service-level agreement"},{"key":"D","text":"Non-disclosure agreement"}]'::jsonb,
  'B',
  'Standard Contractual Clauses (SCCs) are legal mechanisms approved by the EU for transferring personal data to countries outside the EEA that lack an adequacy decision. They ensure the receiving party provides adequate data protection. AUPs govern IT resource usage, SLAs define service metrics, and NDAs protect confidential information.',
  'hard',
  ARRAY['compliance','gdpr','sccs','cross-border','data-transfer','obj-5.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Under GDPR, a data subject requests a copy of all personal data the organization holds about them. Which privacy right is being exercised?',
  '[{"key":"A","text":"Right to be forgotten"},{"key":"B","text":"Right to access"},{"key":"C","text":"Right to data portability"},{"key":"D","text":"Right to restrict processing"}]'::jsonb,
  'B',
  'The right to access (Subject Access Request) allows individuals to obtain a copy of their personal data and information about how it is processed. The right to be forgotten requests deletion, data portability requests data in a portable format for transfer to another provider, and right to restrict limits processing activities.',
  'medium',
  ARRAY['compliance','gdpr','right-to-access','privacy','obj-5.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Under GDPR, an individual requests their personal data in a machine-readable format so they can transfer it to a competing service. Which right is this?',
  '[{"key":"A","text":"Right to access"},{"key":"B","text":"Right to rectification"},{"key":"C","text":"Right to data portability"},{"key":"D","text":"Right to object"}]'::jsonb,
  'C',
  'The right to data portability allows individuals to receive their personal data in a structured, commonly used, machine-readable format and transfer it to another service provider. Right to access provides a copy of data, rectification corrects inaccurate data, and right to object allows challenging certain data processing.',
  'medium',
  ARRAY['compliance','gdpr','data-portability','privacy','obj-5.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

-- ─── 5.5 Audits and assessments ───────────────────────────────────────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A penetration tester is given partial information about the target — they know the IP ranges but not the internal architecture. What type of test is this?',
  '[{"key":"A","text":"Known environment (white box)"},{"key":"B","text":"Partially known environment (gray box)"},{"key":"C","text":"Unknown environment (black box)"},{"key":"D","text":"Red team exercise"}]'::jsonb,
  'B',
  'A partially known environment (gray box) test provides some information about the target (e.g., IP ranges, user accounts) but not full details. This simulates an insider or a compromised external account. Known environment provides everything, unknown provides nothing, and a red team exercise is a comprehensive adversary simulation.',
  'easy',
  ARRAY['audits','penetration-testing','gray-box','obj-5.5']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A penetration tester uses nmap to scan the target network for open ports and running services. What type of reconnaissance is this?',
  '[{"key":"A","text":"Passive reconnaissance"},{"key":"B","text":"Active reconnaissance"},{"key":"C","text":"Social engineering"},{"key":"D","text":"Vulnerability scanning"}]'::jsonb,
  'B',
  'Active reconnaissance directly interacts with the target system by sending packets to discover open ports, services, and potential entry points. Passive reconnaissance uses only publicly available information without touching the target, social engineering targets humans, and vulnerability scanning specifically checks for known weaknesses.',
  'easy',
  ARRAY['audits','active-reconnaissance','nmap','scanning','obj-5.5']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization''s internal audit team reviews security controls annually. A government regulator also conducts an audit every two years. What is the key difference?',
  '[{"key":"A","text":"Internal audits are more thorough"},{"key":"B","text":"Regulatory audits can result in legal penalties for non-compliance"},{"key":"C","text":"Internal audits are always automated"},{"key":"D","text":"Regulatory audits are optional"}]'::jsonb,
  'B',
  'Regulatory audits are conducted by government agencies and can result in legal penalties, fines, sanctions, or loss of operating licenses for non-compliance. Internal audits are self-assessments that identify areas for improvement but lack external enforcement power. Neither is inherently more thorough, internal audits are not always automated, and regulatory audits are mandatory when required by law.',
  'medium',
  ARRAY['audits','internal-audit','regulatory','compliance','obj-5.5']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'After completing a security assessment, the auditor provides a formal written statement confirming that the organization''s controls meet the specified criteria. What is this called?',
  '[{"key":"A","text":"Risk register"},{"key":"B","text":"Attestation"},{"key":"C","text":"Gap analysis"},{"key":"D","text":"Vulnerability report"}]'::jsonb,
  'B',
  'Attestation is a formal statement by an authorized party confirming that an organization''s security controls meet specified criteria or standards. A risk register documents identified risks, a gap analysis identifies deficiencies, and a vulnerability report lists technical weaknesses found during scanning.',
  'medium',
  ARRAY['audits','attestation','formal-statement','compliance','obj-5.5']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

-- ─── 5.6 Security awareness practices ─────────────────────────────────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An employee follows an authorized person through a secured door without using their own access badge. What social engineering technique is this?',
  '[{"key":"A","text":"Shoulder surfing"},{"key":"B","text":"Tailgating"},{"key":"C","text":"Pretexting"},{"key":"D","text":"Dumpster diving"}]'::jsonb,
  'B',
  'Tailgating (piggybacking) is when an unauthorized person follows an authorized person through a secured entrance without authenticating. Shoulder surfing is observing someone''s screen or keyboard, pretexting creates a fabricated scenario, and dumpster diving searches through trash for sensitive information.',
  'easy',
  ARRAY['security-awareness','tailgating','physical-security','social-engineering','obj-5.6']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security team finds sensitive documents in the recycling bins outside the office. An attacker could use these to gather intelligence. Which awareness topic should be reinforced?',
  '[{"key":"A","text":"Password management"},{"key":"B","text":"Dumpster diving prevention and secure document disposal"},{"key":"C","text":"Phishing awareness"},{"key":"D","text":"Encryption standards"}]'::jsonb,
  'B',
  'Dumpster diving is the practice of searching through an organization''s trash for sensitive information. Awareness training should emphasize secure document disposal (shredding) and clean desk policies. Password management addresses credential security, phishing addresses email threats, and encryption protects data in digital form.',
  'easy',
  ARRAY['security-awareness','dumpster-diving','document-disposal','obj-5.6']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization measures the effectiveness of its security awareness program by tracking phishing simulation click rates over time, reporting rates, and time-to-report. What do these metrics indicate?',
  '[{"key":"A","text":"The organization''s technical security posture"},{"key":"B","text":"The maturity and effectiveness of the security awareness program"},{"key":"C","text":"The number of actual phishing attacks blocked"},{"key":"D","text":"The performance of the email filtering system"}]'::jsonb,
  'B',
  'These metrics (click rates, reporting rates, time-to-report) directly measure human behavior changes resulting from security awareness training — indicating program maturity and effectiveness. They don''t measure technical controls, actual attack volumes, or email filter performance.',
  'medium',
  ARRAY['security-awareness','metrics','effectiveness','training','obj-5.6']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Security awareness training teaches employees to recognize behaviors such as a colleague suddenly working unusual hours, accessing files outside their role, or expressing dissatisfaction. What type of threat does this training address?',
  '[{"key":"A","text":"Advanced persistent threat"},{"key":"B","text":"Insider threat"},{"key":"C","text":"Zero-day exploit"},{"key":"D","text":"Supply chain attack"}]'::jsonb,
  'B',
  'Insider threat awareness training teaches employees to recognize behavioral indicators that a colleague may pose a security risk — unusual access patterns, after-hours activity, or expressed grievances. APTs are sophisticated external attacks, zero-day exploits target unknown vulnerabilities, and supply chain attacks compromise vendors.',
  'medium',
  ARRAY['security-awareness','insider-threat','behavioral-indicators','obj-5.6']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization provides role-specific security training: executives learn about BEC and strategic risks, developers learn about secure coding, and HR learns about data privacy. What approach is this?',
  '[{"key":"A","text":"Compliance-based training"},{"key":"B","text":"Role-based security awareness training"},{"key":"C","text":"Gamified learning"},{"key":"D","text":"Computer-based training (CBT)"}]'::jsonb,
  'B',
  'Role-based security awareness training tailors content to the specific risks and responsibilities of each role, making it more relevant and effective than generic training. Compliance-based training focuses on regulatory requirements, gamified learning uses game elements for engagement, and CBT is a delivery method rather than a content approach.',
  'medium',
  ARRAY['security-awareness','role-based','training','effectiveness','obj-5.6']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'The CISO presents a quarterly security report to the board of directors showing risk trends, incident statistics, compliance status, and investment recommendations. What is the PRIMARY purpose of this report?',
  '[{"key":"A","text":"To justify the security team''s headcount"},{"key":"B","text":"To enable informed risk decisions at the executive level"},{"key":"C","text":"To demonstrate technical vulnerabilities in detail"},{"key":"D","text":"To replace the need for external audits"}]'::jsonb,
  'B',
  'Executive security reporting translates technical security data into business-relevant information that enables the board to make informed risk management decisions and allocate resources appropriately. It''s not primarily about headcount justification, doesn''t need technical detail, and complements rather than replaces external audits.',
  'hard',
  ARRAY['governance','executive-reporting','board','risk-communication','obj-5.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '5.0';
