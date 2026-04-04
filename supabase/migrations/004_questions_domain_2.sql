-- Domain 2.0: Threats, Vulnerabilities, and Mitigations (22 new questions)
-- Objectives: 2.1-2.5

-- ─── 2.1 Compare and contrast common threat actors and motivations ───────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A government-funded group launches a sophisticated cyberattack against a foreign country''s critical infrastructure. Which threat actor type does this describe?',
  '[{"key":"A","text":"Hacktivist"},{"key":"B","text":"Insider threat"},{"key":"C","text":"Nation-state"},{"key":"D","text":"Organized crime"}]'::jsonb,
  'C',
  'Nation-state threat actors are sponsored by governments and target other nations'' critical infrastructure, military systems, or intellectual property. They have significant resources and sophisticated capabilities. Hacktivists are motivated by political beliefs, insider threats come from within the organization, and organized crime is motivated by financial gain.',
  'easy',
  ARRAY['threat-actors','nation-state','apt','obj-2.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An employee uses a personal cloud storage service to share company files without IT approval. Which threat actor category BEST describes this behavior?',
  '[{"key":"A","text":"Insider threat"},{"key":"B","text":"Shadow IT"},{"key":"C","text":"Unskilled attacker"},{"key":"D","text":"Hacktivist"}]'::jsonb,
  'B',
  'Shadow IT refers to the use of unauthorized technology, applications, or services within an organization without IT department knowledge or approval. While the employee may not have malicious intent, shadow IT creates security risks because these services bypass corporate security controls. An insider threat implies intentional harm, an unskilled attacker is an external threat, and a hacktivist is motivated by ideology.',
  'medium',
  ARRAY['threat-actors','shadow-it','insider-risk','obj-2.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A threat actor group defaces a government website to protest new surveillance legislation. What is their PRIMARY motivation?',
  '[{"key":"A","text":"Financial gain"},{"key":"B","text":"Espionage"},{"key":"C","text":"Philosophical/political beliefs"},{"key":"D","text":"Revenge"}]'::jsonb,
  'C',
  'Hacktivists are motivated by philosophical or political beliefs and use cyberattacks (such as website defacement or DDoS) to make political statements or protest. Financial gain motivates organized crime, espionage involves stealing secrets (typically nation-state), and revenge is a personal motivation against a specific target.',
  'easy',
  ARRAY['threat-actors','hacktivism','motivations','obj-2.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Which attribute BEST distinguishes a nation-state threat actor from an organized crime group?',
  '[{"key":"A","text":"Financial motivation"},{"key":"B","text":"Level of sophistication and resources"},{"key":"C","text":"Use of social engineering"},{"key":"D","text":"Internal access to the target"}]'::jsonb,
  'B',
  'Nation-state actors have access to extensive government resources and funding, enabling highly sophisticated attacks (advanced persistent threats). While organized crime can be skilled, they typically lack the sustained resources and state-level intelligence capabilities. Both may use social engineering, financial motivation is primarily organized crime, and internal access characterizes insider threats.',
  'hard',
  ARRAY['threat-actors','nation-state','organized-crime','obj-2.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- ─── 2.2 Explain common threat vectors and attack surfaces ──────────────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An attacker sends a text message pretending to be a bank, asking the victim to click a link to verify their account. What type of attack is this?',
  '[{"key":"A","text":"Phishing"},{"key":"B","text":"Vishing"},{"key":"C","text":"Smishing"},{"key":"D","text":"Whaling"}]'::jsonb,
  'C',
  'Smishing (SMS phishing) uses text messages to deceive victims into clicking malicious links or providing sensitive information. Phishing uses email, vishing uses voice calls, and whaling targets high-profile executives. All are forms of social engineering but use different communication channels.',
  'easy',
  ARRAY['social-engineering','smishing','threat-vectors','obj-2.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An attacker registers the domain "go0gle.com" (with a zero instead of the letter O) to trick users into entering their credentials. What technique is this?',
  '[{"key":"A","text":"Watering hole attack"},{"key":"B","text":"Brand impersonation"},{"key":"C","text":"Typosquatting"},{"key":"D","text":"Pretexting"}]'::jsonb,
  'C',
  'Typosquatting involves registering domains that are slight misspellings or visual lookalikes of legitimate domains to capture traffic from users who mistype URLs. Brand impersonation is a broader category of pretending to be a trusted brand, a watering hole compromises websites the target frequently visits, and pretexting creates a fabricated scenario to manipulate victims.',
  'medium',
  ARRAY['social-engineering','typosquatting','threat-vectors','obj-2.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An attacker compromises a popular industry news website knowing that employees of a target organization visit it daily. What type of attack is this?',
  '[{"key":"A","text":"Phishing"},{"key":"B","text":"Watering hole"},{"key":"C","text":"Supply chain attack"},{"key":"D","text":"Business email compromise"}]'::jsonb,
  'B',
  'A watering hole attack compromises a website that the target group is known to visit frequently, then uses it to deliver malware or exploit visitors. It is named after the predator tactic of waiting at a water source for prey. Phishing sends deceptive messages directly, supply chain attacks target vendors/suppliers, and BEC involves impersonating executives via email.',
  'medium',
  ARRAY['social-engineering','watering-hole','threat-vectors','obj-2.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An attacker calls an employee pretending to be from the IT help desk and asks for their password to "fix a critical system issue." Which social engineering technique is being used?',
  '[{"key":"A","text":"Tailgating"},{"key":"B","text":"Pretexting"},{"key":"C","text":"Baiting"},{"key":"D","text":"Shoulder surfing"}]'::jsonb,
  'B',
  'Pretexting involves creating a fabricated scenario (pretext) to manipulate the victim into providing information or performing actions. The attacker builds a believable story — in this case, posing as IT support with an urgent issue. Tailgating is following someone through a secure door, baiting leaves infected media for someone to find, and shoulder surfing involves observing someone''s screen or keystrokes.',
  'easy',
  ARRAY['social-engineering','pretexting','vishing','obj-2.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- ─── 2.3 Explain various types of vulnerabilities ───────────────────────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An attacker sends more data to a program''s memory allocation than it can handle, overwriting adjacent memory and potentially executing arbitrary code. What type of vulnerability is this?',
  '[{"key":"A","text":"Race condition"},{"key":"B","text":"Buffer overflow"},{"key":"C","text":"SQL injection"},{"key":"D","text":"Memory leak"}]'::jsonb,
  'B',
  'A buffer overflow occurs when a program writes data beyond the boundaries of allocated memory, potentially overwriting adjacent memory with attacker-controlled data that can redirect execution flow. A race condition exploits timing between operations, SQL injection targets database queries, and a memory leak is a programming error where allocated memory is not properly freed.',
  'medium',
  ARRAY['vulnerabilities','buffer-overflow','application-security','obj-2.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A web application displays user-submitted content without sanitization, allowing an attacker to inject JavaScript that steals session cookies from other users. What vulnerability is this?',
  '[{"key":"A","text":"SQL injection"},{"key":"B","text":"Cross-site scripting (XSS)"},{"key":"C","text":"Cross-site request forgery (CSRF)"},{"key":"D","text":"Server-side request forgery (SSRF)"}]'::jsonb,
  'B',
  'Cross-site scripting (XSS) occurs when a web application includes untrusted data in output without proper sanitization, allowing attackers to inject client-side scripts that execute in other users'' browsers. SQL injection targets database queries, CSRF forces users to perform unwanted actions on authenticated sites, and SSRF makes the server perform requests to unintended locations.',
  'medium',
  ARRAY['vulnerabilities','xss','web-security','obj-2.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A virtual machine gains access to the host operating system by exploiting a flaw in the hypervisor. What is this type of attack called?',
  '[{"key":"A","text":"Privilege escalation"},{"key":"B","text":"Container escape"},{"key":"C","text":"VM escape"},{"key":"D","text":"Resource reuse"}]'::jsonb,
  'C',
  'VM escape occurs when an attacker breaks out of an isolated virtual machine and interacts directly with the hypervisor or host OS, potentially accessing other VMs or the host system. Privilege escalation is gaining higher permissions within a system, container escape is breaking out of a container runtime, and resource reuse involves accessing leftover data from previously allocated resources.',
  'hard',
  ARRAY['vulnerabilities','vm-escape','virtualization','obj-2.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An attacker exploits a vulnerability where a system checks a user''s permissions and then performs an action, but the permissions change between the check and the action. What type of vulnerability is this?',
  '[{"key":"A","text":"Buffer overflow"},{"key":"B","text":"Race condition (TOC/TOU)"},{"key":"C","text":"Memory injection"},{"key":"D","text":"Malicious update"}]'::jsonb,
  'B',
  'A Time-of-Check to Time-of-Use (TOC/TOU) race condition occurs when a system verifies permissions at one point in time but the state changes before the action is performed, creating a window for exploitation. Buffer overflow writes beyond memory boundaries, memory injection inserts code into a process, and malicious update involves compromised software updates.',
  'hard',
  ARRAY['vulnerabilities','race-condition','toctou','obj-2.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A user installs an application on their smartphone from a source outside the official app store. What is this practice called?',
  '[{"key":"A","text":"Jailbreaking"},{"key":"B","text":"Rooting"},{"key":"C","text":"Side loading"},{"key":"D","text":"Sandboxing"}]'::jsonb,
  'C',
  'Side loading is the process of installing applications from sources other than the official app store, bypassing the store''s security vetting process. Jailbreaking removes manufacturer restrictions on iOS devices, rooting gains superuser access on Android, and sandboxing isolates applications in a restricted environment for security.',
  'easy',
  ARRAY['vulnerabilities','mobile-device','side-loading','obj-2.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- ─── 2.4 Given a scenario, analyze indicators of malicious activity ─────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security analyst discovers that a program installed itself on multiple systems across the network without any user interaction. Which type of malware exhibits this behavior?',
  '[{"key":"A","text":"Virus"},{"key":"B","text":"Trojan"},{"key":"C","text":"Worm"},{"key":"D","text":"Spyware"}]'::jsonb,
  'C',
  'Worms are self-replicating malware that spread across networks without requiring user interaction or a host file. They exploit network vulnerabilities to propagate autonomously. Viruses require a host file and user action to spread, trojans disguise themselves as legitimate software and do not self-replicate, and spyware secretly monitors user activity.',
  'easy',
  ARRAY['malware','worm','indicators','obj-2.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A user notices their antivirus is disabled and cannot be re-enabled, and system tools like Task Manager are hidden. Which type of malware is MOST likely responsible?',
  '[{"key":"A","text":"Adware"},{"key":"B","text":"Rootkit"},{"key":"C","text":"Keylogger"},{"key":"D","text":"Bloatware"}]'::jsonb,
  'B',
  'Rootkits operate at a deep system level and can hide their presence by modifying OS components, disabling security software, and concealing processes from system tools. Adware displays unwanted advertisements, keyloggers record keystrokes, and bloatware is unwanted pre-installed software that consumes resources but is not typically malicious in this way.',
  'medium',
  ARRAY['malware','rootkit','indicators','obj-2.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security team notices that a user account logged in from New York and then from Tokyo within 30 minutes. Which indicator of compromise does this represent?',
  '[{"key":"A","text":"Account lockout"},{"key":"B","text":"Impossible travel"},{"key":"C","text":"Concurrent session usage"},{"key":"D","text":"Resource consumption"}]'::jsonb,
  'B',
  'Impossible travel is an indicator where a user account shows activity from two geographically distant locations in a timeframe that makes physical travel between them impossible. This strongly suggests the account has been compromised. Account lockout occurs after too many failed attempts, concurrent sessions mean simultaneous logins, and resource consumption indicates unusual system usage.',
  'medium',
  ARRAY['indicators','impossible-travel','account-compromise','obj-2.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An attacker overwhelms a web server by sending massive amounts of traffic from thousands of compromised systems simultaneously. What type of attack is this?',
  '[{"key":"A","text":"On-path attack"},{"key":"B","text":"DNS poisoning"},{"key":"C","text":"Distributed Denial of Service (DDoS)"},{"key":"D","text":"Credential replay"}]'::jsonb,
  'C',
  'A Distributed Denial of Service (DDoS) attack uses multiple compromised systems (a botnet) to flood a target with traffic, overwhelming its capacity and making it unavailable to legitimate users. An on-path attack intercepts communications, DNS poisoning redirects traffic by corrupting DNS records, and credential replay reuses captured authentication data.',
  'easy',
  ARRAY['network-attacks','ddos','denial-of-service','obj-2.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An attacker uses a previously captured authentication token to gain access to a system without knowing the user''s password. What type of attack is this?',
  '[{"key":"A","text":"Password spraying"},{"key":"B","text":"Brute force"},{"key":"C","text":"Credential replay"},{"key":"D","text":"Birthday attack"}]'::jsonb,
  'C',
  'A credential replay attack captures and reuses valid authentication tokens, session IDs, or hashed credentials to impersonate a legitimate user without needing the actual password. Password spraying tries one common password across many accounts, brute force tries many passwords against one account, and a birthday attack exploits hash collision probability.',
  'medium',
  ARRAY['attacks','credential-replay','authentication','obj-2.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- ─── 2.5 Explain purpose of mitigation techniques ──────────────────────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization divides its network into separate segments for finance, HR, and engineering departments. Which mitigation technique is being applied?',
  '[{"key":"A","text":"Encryption"},{"key":"B","text":"Segmentation"},{"key":"C","text":"Application allow list"},{"key":"D","text":"Least privilege"}]'::jsonb,
  'B',
  'Network segmentation divides a network into isolated segments to limit lateral movement — if an attacker compromises one segment, they cannot easily access others. Encryption protects data confidentiality, application allow lists restrict which software can run, and least privilege limits user permissions to the minimum needed.',
  'easy',
  ARRAY['mitigation','segmentation','network-security','obj-2.5']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A company configures its workstations to only execute applications from a pre-approved list. Any software not on the list is blocked. Which hardening technique is this?',
  '[{"key":"A","text":"Patch management"},{"key":"B","text":"Configuration enforcement"},{"key":"C","text":"Application allow list"},{"key":"D","text":"Host-based firewall"}]'::jsonb,
  'C',
  'An application allow list (whitelist) only permits pre-approved applications to execute, blocking all others by default. This prevents unauthorized or malicious software from running. Patch management keeps software updated, configuration enforcement maintains security settings, and a host-based firewall controls network traffic to/from a specific device.',
  'easy',
  ARRAY['mitigation','allow-list','hardening','obj-2.5']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'After discovering a critical vulnerability in a web server, the security team cannot immediately apply a patch due to compatibility concerns. They deploy a web application firewall (WAF) rule to block exploit attempts instead. What type of control is this?',
  '[{"key":"A","text":"Corrective control"},{"key":"B","text":"Compensating control"},{"key":"C","text":"Deterrent control"},{"key":"D","text":"Detective control"}]'::jsonb,
  'B',
  'A compensating control is an alternative security measure used when the primary control (patching) cannot be implemented. The WAF rule mitigates the risk temporarily by blocking known exploit patterns until the patch can be safely applied. A corrective control fixes damage after an incident, a deterrent discourages attacks, and a detective control identifies incidents.',
  'hard',
  ARRAY['mitigation','compensating-control','hardening','obj-2.5']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security administrator removes unnecessary services, disables unused ports, and changes default passwords on a new server before deploying it. What is this process called?',
  '[{"key":"A","text":"Patching"},{"key":"B","text":"Monitoring"},{"key":"C","text":"Hardening"},{"key":"D","text":"Isolation"}]'::jsonb,
  'C',
  'Hardening is the process of reducing a system''s attack surface by removing unnecessary software, disabling unused services and ports, changing default credentials, and applying security configurations. Patching updates software to fix vulnerabilities, monitoring observes system activity, and isolation separates a system from the rest of the network.',
  'easy',
  ARRAY['mitigation','hardening','configuration','obj-2.5']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';
