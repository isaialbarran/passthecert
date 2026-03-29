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
where e.slug = 'comptia-security-plus' and d.code = '5.0'

-- ─── ADDITIONAL QUESTIONS (4 more per domain = 20 total) ────────────────────

-- Domain 1.0 – General Security Concepts (need 4 more)
union all
select e.id, d.id,
  'Which of the following BEST describes the concept of defense in depth?',
  '[{"key":"A","text":"Using a single strong firewall to protect the network"},{"key":"B","text":"Implementing multiple layers of security controls"},{"key":"C","text":"Encrypting all data at rest and in transit"},{"key":"D","text":"Restricting all users to read-only access"}]'::jsonb,
  'B',
  'Defense in depth is a security strategy that employs multiple layers of controls (physical, technical, administrative) so that if one layer fails, others continue to provide protection. A single firewall is only one layer. Encryption and access restrictions are individual controls, not layered strategies.',
  'easy',
  array['security-concepts','defense-in-depth']
from public.exams e, public.domains d
where e.slug = 'comptia-security-plus' and d.code = '1.0'

union all
select e.id, d.id,
  'An organization classifies its data into Public, Internal, Confidential, and Restricted categories. Which security principle does this BEST represent?',
  '[{"key":"A","text":"Least privilege"},{"key":"B","text":"Data classification"},{"key":"C","text":"Separation of duties"},{"key":"D","text":"Need to know"}]'::jsonb,
  'B',
  'Data classification is the process of categorizing data based on its sensitivity level and the impact if disclosed. Least privilege limits access rights, separation of duties divides tasks to prevent fraud, and need to know restricts access based on job requirements.',
  'easy',
  array['security-concepts','data-classification','governance']
from public.exams e, public.domains d
where e.slug = 'comptia-security-plus' and d.code = '1.0'

union all
select e.id, d.id,
  'Which of the following authentication methods uses something you are?',
  '[{"key":"A","text":"Smart card"},{"key":"B","text":"PIN code"},{"key":"C","text":"Fingerprint scanner"},{"key":"D","text":"Security token"}]'::jsonb,
  'C',
  'Biometric authentication (fingerprint, retina scan, facial recognition) uses "something you are." A smart card and security token are "something you have," and a PIN is "something you know." Multi-factor authentication combines two or more of these categories.',
  'easy',
  array['security-concepts','authentication','biometrics']
from public.exams e, public.domains d
where e.slug = 'comptia-security-plus' and d.code = '1.0'

union all
select e.id, d.id,
  'What is the PRIMARY difference between symmetric and asymmetric encryption?',
  '[{"key":"A","text":"Symmetric encryption is slower than asymmetric"},{"key":"B","text":"Asymmetric encryption uses the same key for encryption and decryption"},{"key":"C","text":"Symmetric encryption uses a single shared key while asymmetric uses a key pair"},{"key":"D","text":"Asymmetric encryption cannot be used for digital signatures"}]'::jsonb,
  'C',
  'Symmetric encryption uses one shared secret key for both encryption and decryption (e.g., AES). Asymmetric encryption uses a key pair — a public key to encrypt and a private key to decrypt (e.g., RSA). Symmetric is actually faster than asymmetric, and asymmetric encryption is used for digital signatures.',
  'medium',
  array['cryptography','encryption','symmetric','asymmetric']
from public.exams e, public.domains d
where e.slug = 'comptia-security-plus' and d.code = '1.0'

-- Domain 2.0 – Threats, Vulnerabilities, and Mitigations (need 4 more)
union all
select e.id, d.id,
  'A user receives an email that appears to be from their bank asking them to verify their account by clicking a link. The link leads to a fake website. What type of attack is this?',
  '[{"key":"A","text":"Vishing"},{"key":"B","text":"Phishing"},{"key":"C","text":"Whaling"},{"key":"D","text":"Smishing"}]'::jsonb,
  'B',
  'Phishing is a social engineering attack using fraudulent emails that appear to come from a trusted source, directing victims to fake websites to steal credentials. Vishing uses voice calls, smishing uses SMS text messages, and whaling targets high-profile executives specifically.',
  'easy',
  array['social-engineering','phishing','attacks']
from public.exams e, public.domains d
where e.slug = 'comptia-security-plus' and d.code = '2.0'

union all
select e.id, d.id,
  'Which type of malware encrypts a victim''s files and demands payment for the decryption key?',
  '[{"key":"A","text":"Trojan"},{"key":"B","text":"Worm"},{"key":"C","text":"Ransomware"},{"key":"D","text":"Rootkit"}]'::jsonb,
  'C',
  'Ransomware encrypts files or locks systems and demands a ransom payment (usually cryptocurrency) for the decryption key. Trojans disguise themselves as legitimate software, worms self-replicate across networks, and rootkits hide their presence to maintain persistent access.',
  'easy',
  array['malware','ransomware','threats']
from public.exams e, public.domains d
where e.slug = 'comptia-security-plus' and d.code = '2.0'

union all
select e.id, d.id,
  'An attacker exploits a vulnerability on the same day it is discovered, before a patch is available. What is this called?',
  '[{"key":"A","text":"Buffer overflow"},{"key":"B","text":"Zero-day exploit"},{"key":"C","text":"Logic bomb"},{"key":"D","text":"Privilege escalation"}]'::jsonb,
  'B',
  'A zero-day exploit takes advantage of a previously unknown vulnerability before the vendor has released a patch (day zero). Buffer overflow is a specific vulnerability type, a logic bomb is triggered by a condition, and privilege escalation is a post-exploitation technique.',
  'medium',
  array['vulnerabilities','zero-day','exploits']
from public.exams e, public.domains d
where e.slug = 'comptia-security-plus' and d.code = '2.0'

union all
select e.id, d.id,
  'Which vulnerability allows an attacker to inject malicious SQL statements into an application''s database query?',
  '[{"key":"A","text":"Cross-site scripting (XSS)"},{"key":"B","text":"SQL injection"},{"key":"C","text":"Cross-site request forgery (CSRF)"},{"key":"D","text":"XML external entity (XXE)"}]'::jsonb,
  'B',
  'SQL injection occurs when user input is not properly sanitized and is included directly in SQL queries, allowing attackers to manipulate database operations. XSS injects scripts into web pages, CSRF tricks users into making unwanted requests, and XXE exploits XML parsers.',
  'medium',
  array['vulnerabilities','sql-injection','web-security']
from public.exams e, public.domains d
where e.slug = 'comptia-security-plus' and d.code = '2.0'

-- Domain 3.0 – Security Architecture (need 4 more)
union all
select e.id, d.id,
  'Which network zone sits between a private internal network and the public internet, hosting public-facing services?',
  '[{"key":"A","text":"VLAN"},{"key":"B","text":"DMZ (Demilitarized Zone)"},{"key":"C","text":"Intranet"},{"key":"D","text":"Air gap"}]'::jsonb,
  'B',
  'A DMZ (Demilitarized Zone) is a perimeter network segment that hosts externally accessible services (web servers, email servers) while isolating them from the internal network. VLANs segment traffic logically, an intranet is internal only, and an air gap physically isolates a network.',
  'easy',
  array['network-architecture','dmz','network-security']
from public.exams e, public.domains d
where e.slug = 'comptia-security-plus' and d.code = '3.0'

union all
select e.id, d.id,
  'An organization uses a cloud deployment where they manage the application and data while the provider manages the infrastructure, OS, and runtime. Which cloud model is this?',
  '[{"key":"A","text":"Infrastructure as a Service (IaaS)"},{"key":"B","text":"Platform as a Service (PaaS)"},{"key":"C","text":"Software as a Service (SaaS)"},{"key":"D","text":"Function as a Service (FaaS)"}]'::jsonb,
  'B',
  'Platform as a Service (PaaS) provides a managed environment where the provider handles infrastructure, operating system, and runtime, while the customer manages applications and data. IaaS provides only infrastructure, SaaS delivers complete applications, and FaaS runs individual functions.',
  'medium',
  array['cloud','paas','security-architecture']
from public.exams e, public.domains d
where e.slug = 'comptia-security-plus' and d.code = '3.0'

union all
select e.id, d.id,
  'Which security model implements mandatory access control based on security labels assigned to both subjects and objects?',
  '[{"key":"A","text":"Discretionary Access Control (DAC)"},{"key":"B","text":"Role-Based Access Control (RBAC)"},{"key":"C","text":"Mandatory Access Control (MAC)"},{"key":"D","text":"Attribute-Based Access Control (ABAC)"}]'::jsonb,
  'C',
  'Mandatory Access Control (MAC) uses security labels (classifications like Top Secret, Secret, Confidential) assigned by the system administrator. Access decisions are enforced by the system, not the owner. DAC lets owners set permissions, RBAC uses roles, and ABAC uses attributes and policies.',
  'medium',
  array['access-control','mac','security-models']
from public.exams e, public.domains d
where e.slug = 'comptia-security-plus' and d.code = '3.0'

union all
select e.id, d.id,
  'Which of the following BEST describes a virtual private cloud (VPC)?',
  '[{"key":"A","text":"A physical server dedicated to a single tenant"},{"key":"B","text":"An isolated section of a public cloud for a single organization"},{"key":"C","text":"A private data center connected via VPN"},{"key":"D","text":"A cloud-hosted virtual desktop environment"}]'::jsonb,
  'B',
  'A Virtual Private Cloud (VPC) is a logically isolated section within a public cloud environment that provides private network space for an organization''s resources. It is not a physical server, not a private data center with VPN, and not a virtual desktop infrastructure.',
  'medium',
  array['cloud','vpc','security-architecture']
from public.exams e, public.domains d
where e.slug = 'comptia-security-plus' and d.code = '3.0'

-- Domain 4.0 – Security Operations (need 4 more)
union all
select e.id, d.id,
  'Which of the following is the FIRST step in the incident response process?',
  '[{"key":"A","text":"Containment"},{"key":"B","text":"Eradication"},{"key":"C","text":"Preparation"},{"key":"D","text":"Recovery"}]'::jsonb,
  'C',
  'The incident response process follows: Preparation → Identification → Containment → Eradication → Recovery → Lessons Learned. Preparation is the first step and includes establishing policies, procedures, communication plans, and training the response team before any incident occurs.',
  'easy',
  array['incident-response','security-operations']
from public.exams e, public.domains d
where e.slug = 'comptia-security-plus' and d.code = '4.0'

union all
select e.id, d.id,
  'A security team wants to test their network defenses by simulating real-world attacks without prior knowledge of the internal systems. What type of testing is this?',
  '[{"key":"A","text":"White-box testing"},{"key":"B","text":"Gray-box testing"},{"key":"C","text":"Black-box testing"},{"key":"D","text":"Regression testing"}]'::jsonb,
  'C',
  'Black-box testing (also called external or blind testing) simulates attacks without prior knowledge of the target systems, mimicking a real attacker. White-box testing provides full knowledge, gray-box provides partial knowledge, and regression testing verifies that changes haven''t broken existing functionality.',
  'medium',
  array['penetration-testing','security-operations','vulnerability-assessment']
from public.exams e, public.domains d
where e.slug = 'comptia-security-plus' and d.code = '4.0'

union all
select e.id, d.id,
  'Which of the following tools is used to capture and analyze network traffic in real time?',
  '[{"key":"A","text":"Nmap"},{"key":"B","text":"Wireshark"},{"key":"C","text":"Nessus"},{"key":"D","text":"Burp Suite"}]'::jsonb,
  'B',
  'Wireshark is a packet capture and analysis tool that allows security professionals to inspect network traffic in real time. Nmap is a network scanner for discovering hosts and services, Nessus is a vulnerability scanner, and Burp Suite is a web application security testing tool.',
  'easy',
  array['network-tools','wireshark','security-operations']
from public.exams e, public.domains d
where e.slug = 'comptia-security-plus' and d.code = '4.0'

union all
select e.id, d.id,
  'What type of backup strategy only copies files that have changed since the last full backup?',
  '[{"key":"A","text":"Full backup"},{"key":"B","text":"Incremental backup"},{"key":"C","text":"Differential backup"},{"key":"D","text":"Snapshot backup"}]'::jsonb,
  'C',
  'A differential backup copies all files that have changed since the last full backup. An incremental backup copies only files changed since the last backup of any type (full or incremental). Full backup copies everything. Snapshots capture the state of a system at a point in time.',
  'medium',
  array['backup','disaster-recovery','security-operations']
from public.exams e, public.domains d
where e.slug = 'comptia-security-plus' and d.code = '4.0'

-- Domain 5.0 – Security Program Management and Oversight (need 4 more)
union all
select e.id, d.id,
  'Which framework is MOST commonly used to assess and improve an organization''s cybersecurity posture in the United States?',
  '[{"key":"A","text":"ITIL"},{"key":"B","text":"COBIT"},{"key":"C","text":"NIST Cybersecurity Framework"},{"key":"D","text":"ISO 27001"}]'::jsonb,
  'C',
  'The NIST Cybersecurity Framework (CSF) is the most widely adopted framework in the US for managing cybersecurity risk. It provides five core functions: Identify, Protect, Detect, Respond, and Recover. ITIL focuses on IT service management, COBIT on IT governance, and ISO 27001 is an international standard more common globally.',
  'medium',
  array['frameworks','nist','governance','compliance']
from public.exams e, public.domains d
where e.slug = 'comptia-security-plus' and d.code = '5.0'

union all
select e.id, d.id,
  'An organization conducts a risk assessment and determines that the cost to mitigate a risk exceeds the potential loss. They decide to accept the risk and document it. What is this called?',
  '[{"key":"A","text":"Risk avoidance"},{"key":"B","text":"Risk transference"},{"key":"C","text":"Risk acceptance"},{"key":"D","text":"Risk mitigation"}]'::jsonb,
  'C',
  'Risk acceptance means acknowledging the risk and choosing not to take action, typically because the cost of mitigation outweighs the potential impact. Risk avoidance eliminates the activity causing risk, risk transference shifts risk to another party (insurance), and risk mitigation reduces the risk impact or likelihood.',
  'easy',
  array['risk-management','governance','security-program']
from public.exams e, public.domains d
where e.slug = 'comptia-security-plus' and d.code = '5.0'

union all
select e.id, d.id,
  'Which regulation specifically protects the personal data and privacy of individuals in the European Union?',
  '[{"key":"A","text":"HIPAA"},{"key":"B","text":"PCI DSS"},{"key":"C","text":"SOX"},{"key":"D","text":"GDPR"}]'::jsonb,
  'D',
  'The General Data Protection Regulation (GDPR) is an EU regulation that governs the collection, processing, and storage of personal data for EU residents. HIPAA protects health information in the US, PCI DSS secures payment card data, and SOX governs financial reporting for public companies.',
  'easy',
  array['compliance','gdpr','regulations','privacy']
from public.exams e, public.domains d
where e.slug = 'comptia-security-plus' and d.code = '5.0'

union all
select e.id, d.id,
  'What is the PRIMARY purpose of a Business Impact Analysis (BIA)?',
  '[{"key":"A","text":"To identify all vulnerabilities in the network"},{"key":"B","text":"To determine the impact of disruptions to critical business functions"},{"key":"C","text":"To test the effectiveness of security controls"},{"key":"D","text":"To create a list of all IT assets"}]'::jsonb,
  'B',
  'A Business Impact Analysis (BIA) identifies critical business functions and determines the impact (financial, operational, reputational) of disruptions to those functions. It helps establish recovery priorities and objectives (RTO/RPO). Vulnerability scanning identifies weaknesses, security audits test controls, and asset inventory catalogs IT resources.',
  'medium',
  array['business-continuity','bia','risk-management','governance']
from public.exams e, public.domains d
where e.slug = 'comptia-security-plus' and d.code = '5.0';

