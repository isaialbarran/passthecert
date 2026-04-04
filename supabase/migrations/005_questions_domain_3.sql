-- Domain 3.0: Security Architecture (17 new questions)
-- Objectives: 3.1-3.4

-- ─── 3.1 Compare and contrast security implications of different architecture models ─

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A company uses a cloud service where all infrastructure management, including servers, storage, and networking, is handled by the provider. The company only manages its applications and data. Which cloud model is this?',
  '[{"key":"A","text":"Infrastructure as a Service (IaaS)"},{"key":"B","text":"Platform as a Service (PaaS)"},{"key":"C","text":"Software as a Service (SaaS)"},{"key":"D","text":"Function as a Service (FaaS)"}]'::jsonb,
  'B',
  'In PaaS, the cloud provider manages the infrastructure, OS, and runtime environment, while the customer manages applications and data. In IaaS, the customer also manages the OS and runtime. In SaaS, the provider manages everything including the application. FaaS (serverless) runs individual functions without managing any infrastructure.',
  'medium',
  ARRAY['cloud','paas','shared-responsibility','obj-3.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization uses code to automatically provision and configure its cloud infrastructure. Which concept does this describe?',
  '[{"key":"A","text":"Containerization"},{"key":"B","text":"Microservices"},{"key":"C","text":"Infrastructure as Code (IaC)"},{"key":"D","text":"Software-defined networking (SDN)"}]'::jsonb,
  'C',
  'Infrastructure as Code (IaC) uses machine-readable configuration files to automate the provisioning and management of infrastructure, ensuring consistent and repeatable deployments. Containerization packages applications with their dependencies, microservices breaks applications into small independent services, and SDN manages network resources through software abstraction.',
  'easy',
  ARRAY['cloud','iac','automation','obj-3.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A manufacturing plant uses a SCADA system to monitor and control industrial processes. Which security concern is MOST critical for this environment?',
  '[{"key":"A","text":"Data encryption at rest"},{"key":"B","text":"Availability and safety of operations"},{"key":"C","text":"User password complexity"},{"key":"D","text":"Mobile device management"}]'::jsonb,
  'B',
  'Industrial Control Systems (ICS) and SCADA systems prioritize availability and safety above all else because disruptions can cause physical damage, environmental hazards, or endanger human life. While encryption, passwords, and MDM are important in other contexts, the critical nature of industrial processes makes operational continuity the top concern.',
  'medium',
  ARRAY['ics','scada','ot-security','availability','obj-3.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An application is designed as a collection of small, independently deployable services that communicate via APIs. What architecture pattern is this?',
  '[{"key":"A","text":"Monolithic"},{"key":"B","text":"Serverless"},{"key":"C","text":"Microservices"},{"key":"D","text":"Embedded systems"}]'::jsonb,
  'C',
  'Microservices architecture breaks an application into small, loosely coupled services that can be developed, deployed, and scaled independently, communicating through APIs. A monolithic architecture runs as a single unit, serverless runs code without managing servers (but can use any architecture), and embedded systems are specialized hardware-software combinations.',
  'easy',
  ARRAY['architecture','microservices','application-design','obj-3.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Which security consideration is a PRIMARY concern when using IoT devices in an enterprise environment?',
  '[{"key":"A","text":"High computational overhead"},{"key":"B","text":"Limited ability to patch and update firmware"},{"key":"C","text":"Excessive bandwidth consumption"},{"key":"D","text":"Incompatibility with cloud services"}]'::jsonb,
  'B',
  'IoT devices often have limited processing power and memory, making it difficult to run security agents or apply patches. Many IoT devices ship with default credentials, lack encryption, and have infrequent firmware updates — all of which expand the attack surface. While bandwidth and cloud compatibility can be concerns, the inability to patch is the most critical security risk.',
  'medium',
  ARRAY['iot','firmware','patch-management','obj-3.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- ─── 3.2 Given a scenario, apply security principles to secure enterprise infrastructure ─

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security administrator needs to provide secure remote access to the internal network for employees working from home. Which technology should they implement?',
  '[{"key":"A","text":"NAC"},{"key":"B","text":"VPN"},{"key":"C","text":"IDS"},{"key":"D","text":"WAF"}]'::jsonb,
  'B',
  'A Virtual Private Network (VPN) creates an encrypted tunnel between the remote user and the corporate network, allowing secure access to internal resources over the internet. NAC controls device access on the local network, an IDS detects intrusions but doesn''t provide access, and a WAF protects web applications from attacks.',
  'easy',
  ARRAY['vpn','remote-access','network-security','obj-3.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An administrator needs to access servers in a secured network segment. They must first connect to an intermediary hardened system before reaching the target servers. What is this intermediary system called?',
  '[{"key":"A","text":"Proxy server"},{"key":"B","text":"Jump server"},{"key":"C","text":"Load balancer"},{"key":"D","text":"Honeypot"}]'::jsonb,
  'B',
  'A jump server (also called a bastion host) is a hardened intermediary system that administrators connect to first before accessing servers in a secured zone. It provides a single, auditable access point. A proxy server forwards client requests to other servers, a load balancer distributes traffic across servers, and a honeypot is a decoy system to attract attackers.',
  'medium',
  ARRAY['jump-server','bastion-host','network-security','obj-3.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A firewall is configured so that if it experiences a hardware failure, all traffic is blocked. What type of failure mode is this?',
  '[{"key":"A","text":"Fail-open"},{"key":"B","text":"Fail-closed"},{"key":"C","text":"Fail-safe"},{"key":"D","text":"Fail-over"}]'::jsonb,
  'B',
  'Fail-closed (also called fail-secure) means that when a device fails, it blocks all traffic by default — prioritizing security over availability. Fail-open allows all traffic through during a failure (prioritizing availability), fail-safe is a general term for safe failure states, and failover is the automatic switch to a redundant system when the primary fails.',
  'medium',
  ARRAY['firewall','fail-closed','failure-modes','obj-3.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Which type of firewall operates at Layer 7 of the OSI model and can inspect the content of HTTP requests to block SQL injection attacks?',
  '[{"key":"A","text":"Packet-filtering firewall"},{"key":"B","text":"Stateful firewall"},{"key":"C","text":"Web application firewall (WAF)"},{"key":"D","text":"Layer 4 firewall"}]'::jsonb,
  'C',
  'A Web Application Firewall (WAF) operates at Layer 7 (application layer) and inspects HTTP/HTTPS traffic content, enabling it to detect and block application-layer attacks like SQL injection, XSS, and CSRF. Packet-filtering firewalls operate at Layer 3, stateful firewalls track connection states at Layer 4, and Layer 4 firewalls make decisions based on TCP/UDP port information.',
  'medium',
  ARRAY['firewall','waf','layer-7','application-security','obj-3.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- ─── 3.3 Compare and contrast concepts and strategies to protect data ────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Which of the following BEST describes data that is currently being processed by a CPU?',
  '[{"key":"A","text":"Data at rest"},{"key":"B","text":"Data in transit"},{"key":"C","text":"Data in use"},{"key":"D","text":"Data in motion"}]'::jsonb,
  'C',
  'Data in use refers to data that is currently being processed, accessed, or manipulated in memory (RAM) or by the CPU. Data at rest is stored on disk and not actively being accessed, and data in transit (also called data in motion) is being transmitted across a network. Each state requires different security controls.',
  'easy',
  ARRAY['data-protection','data-states','data-in-use','obj-3.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A European company stores customer data on servers located in the United States. Which data protection concept is MOST relevant to this scenario?',
  '[{"key":"A","text":"Data masking"},{"key":"B","text":"Data sovereignty"},{"key":"C","text":"Data segmentation"},{"key":"D","text":"Data tokenization"}]'::jsonb,
  'B',
  'Data sovereignty refers to the concept that data is subject to the laws of the country where it is stored. A European company storing data in the US must comply with both EU regulations (like GDPR) and US laws, which may have conflicting requirements. Data masking obscures data, segmentation separates data by category, and tokenization replaces data with tokens.',
  'medium',
  ARRAY['data-protection','data-sovereignty','compliance','obj-3.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization classifies a document as "Restricted." Who should have access to this document?',
  '[{"key":"A","text":"All employees"},{"key":"B","text":"Only the public relations team"},{"key":"C","text":"Only specifically authorized individuals"},{"key":"D","text":"Anyone with an internet connection"}]'::jsonb,
  'C',
  'Restricted is the highest classification level in most data classification schemes and limits access to only specifically authorized individuals with a clear need to access the data. Public data is accessible to all, confidential is limited to the organization, and restricted is the most tightly controlled. The exact definitions may vary by organization.',
  'easy',
  ARRAY['data-classification','restricted','access-control','obj-3.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A hospital replaces patient Social Security numbers in a test database with fake but realistic-looking numbers that cannot be reversed to the originals. Which technique is being used?',
  '[{"key":"A","text":"Tokenization"},{"key":"B","text":"Encryption"},{"key":"C","text":"Data masking"},{"key":"D","text":"Hashing"}]'::jsonb,
  'C',
  'Data masking replaces sensitive data with realistic but fictitious data that is irreversible — the original data cannot be recovered from the masked version. This is commonly used in test and development environments. Tokenization is reversible through a token vault, encryption is reversible with a key, and hashing produces a fixed-length digest (not realistic-looking replacement data).',
  'hard',
  ARRAY['data-protection','data-masking','privacy','obj-3.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- ─── 3.4 Explain importance of resilience and recovery in security architecture ─

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization maintains a fully equipped alternate data center that can take over operations within minutes of a primary site failure. What type of site is this?',
  '[{"key":"A","text":"Cold site"},{"key":"B","text":"Warm site"},{"key":"C","text":"Hot site"},{"key":"D","text":"Mobile site"}]'::jsonb,
  'C',
  'A hot site is a fully operational duplicate of the primary site with real-time data replication, ready to take over immediately (within minutes). A warm site has equipment and connectivity but requires data restoration (hours to activate), a cold site has only basic infrastructure like power and cooling (days to weeks), and a mobile site is a portable recovery facility.',
  'easy',
  ARRAY['disaster-recovery','hot-site','business-continuity','obj-3.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A company uses two different cloud providers (AWS and Azure) for its production workloads. Which resilience strategy does this represent?',
  '[{"key":"A","text":"Load balancing"},{"key":"B","text":"Multi-cloud systems"},{"key":"C","text":"Platform diversity"},{"key":"D","text":"Geographic dispersion"}]'::jsonb,
  'B',
  'Multi-cloud systems use multiple cloud service providers to avoid vendor lock-in and reduce the risk of a single provider outage taking down all services. Platform diversity is a broader concept of using different operating systems or technologies, load balancing distributes traffic across servers, and geographic dispersion places resources in different locations.',
  'medium',
  ARRAY['resilience','multi-cloud','high-availability','obj-3.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization''s leadership team walks through a simulated ransomware attack scenario, discussing roles and decision-making without actually performing any technical actions. What type of test is this?',
  '[{"key":"A","text":"Penetration test"},{"key":"B","text":"Simulation"},{"key":"C","text":"Tabletop exercise"},{"key":"D","text":"Fail over test"}]'::jsonb,
  'C',
  'A tabletop exercise is a discussion-based session where team members walk through a simulated scenario to review roles, responsibilities, and decision-making processes without performing actual technical operations. A penetration test actively exploits vulnerabilities, a simulation mimics a real attack with technical actions, and a failover test switches to backup systems.',
  'easy',
  ARRAY['resilience','tabletop-exercise','testing','obj-3.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Which backup type copies only the files that have changed since the last backup of ANY type (full or incremental)?',
  '[{"key":"A","text":"Full backup"},{"key":"B","text":"Differential backup"},{"key":"C","text":"Incremental backup"},{"key":"D","text":"Snapshot"}]'::jsonb,
  'C',
  'An incremental backup copies only files changed since the last backup of any type (full or incremental), making it the fastest and smallest backup. A full backup copies everything, a differential copies all changes since the last full backup (growing larger over time), and a snapshot captures the system state at a point in time. Incremental restores require the full backup plus all incremental backups.',
  'medium',
  ARRAY['backup','incremental','disaster-recovery','obj-3.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';
