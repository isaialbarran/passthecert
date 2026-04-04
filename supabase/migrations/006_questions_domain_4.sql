-- Domain 4.0: Security Operations (29 new questions)
-- Objectives: 4.1-4.9

-- ─── 4.1 Given a scenario, apply common security techniques to computing resources ─

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An IT team creates a standard configuration image for all company laptops that includes approved software, security settings, and disabled unnecessary services. What is this practice called?',
  '[{"key":"A","text":"Patch management"},{"key":"B","text":"Secure baseline"},{"key":"C","text":"Configuration drift"},{"key":"D","text":"Change management"}]'::jsonb,
  'B',
  'A secure baseline is a standard configuration that defines the minimum security requirements for a system before deployment. It includes approved software, hardened settings, disabled unnecessary services, and security tools. Patch management updates software, configuration drift is when systems deviate from the baseline, and change management governs how changes are approved.',
  'easy',
  ARRAY['secure-baseline','hardening','configuration','obj-4.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A company allows employees to use their personal smartphones for work email and applications. Which mobile deployment model is this?',
  '[{"key":"A","text":"COPE (Corporate-owned, personally enabled)"},{"key":"B","text":"BYOD (Bring your own device)"},{"key":"C","text":"CYOD (Choose your own device)"},{"key":"D","text":"COBO (Corporate-owned, business only)"}]'::jsonb,
  'B',
  'BYOD (Bring Your Own Device) allows employees to use their personal devices for work purposes. COPE provides company-owned devices that employees can also use personally, CYOD lets employees choose from a list of approved company-purchased devices, and COBO restricts corporate devices to business use only.',
  'easy',
  ARRAY['mobile','byod','deployment-models','obj-4.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Which wireless security protocol provides the STRONGEST encryption and is currently recommended for enterprise Wi-Fi networks?',
  '[{"key":"A","text":"WEP"},{"key":"B","text":"WPA"},{"key":"C","text":"WPA2"},{"key":"D","text":"WPA3"}]'::jsonb,
  'D',
  'WPA3 is the latest and most secure Wi-Fi security protocol, using Simultaneous Authentication of Equals (SAE) to replace the PSK handshake, providing stronger protection against offline dictionary attacks. WEP is deprecated and easily cracked, WPA was a transitional improvement, and WPA2 is still widely used but has known vulnerabilities like the KRACK attack.',
  'easy',
  ARRAY['wireless','wpa3','encryption','obj-4.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A developer runs an automated tool that analyzes source code for security vulnerabilities without executing the program. What type of analysis is this?',
  '[{"key":"A","text":"Dynamic analysis"},{"key":"B","text":"Static code analysis"},{"key":"C","text":"Penetration testing"},{"key":"D","text":"Fuzzing"}]'::jsonb,
  'B',
  'Static code analysis examines source code without executing it, identifying potential vulnerabilities like buffer overflows, SQL injection points, and insecure coding patterns. Dynamic analysis tests the running application, penetration testing actively exploits vulnerabilities, and fuzzing sends random or malformed data to a running program to find crashes.',
  'medium',
  ARRAY['application-security','static-analysis','code-review','obj-4.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

-- ─── 4.2 Explain security implications of proper asset management ───────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Before disposing of old hard drives containing sensitive data, a company uses a degaussing machine to destroy the data. Which asset management phase does this fall under?',
  '[{"key":"A","text":"Acquisition"},{"key":"B","text":"Assignment"},{"key":"C","text":"Monitoring"},{"key":"D","text":"Disposal/decommissioning"}]'::jsonb,
  'D',
  'Disposal/decommissioning is the final phase of the asset lifecycle, which includes sanitization (removing data), destruction (physically destroying media), and certification (documenting that destruction was completed). Degaussing uses a strong magnetic field to erase magnetic media. Acquisition is purchasing assets, assignment allocates them to users, and monitoring tracks their status.',
  'easy',
  ARRAY['asset-management','disposal','sanitization','degaussing','obj-4.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization maintains a database that records every hardware and software asset, including its location, assigned user, and current status. What is this process called?',
  '[{"key":"A","text":"Change management"},{"key":"B","text":"Asset tracking and inventory"},{"key":"C","text":"Risk assessment"},{"key":"D","text":"Configuration management"}]'::jsonb,
  'B',
  'Asset tracking and inventory involves maintaining a comprehensive record of all hardware and software assets, including their location, ownership, classification, and status. This enables the organization to manage its attack surface, ensure compliance, and plan for replacements. Change management governs modifications, risk assessment evaluates threats, and configuration management maintains system settings.',
  'easy',
  ARRAY['asset-management','inventory','tracking','obj-4.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A company discovers that several network devices still use firmware from the manufacturer that is no longer providing security updates. What is the PRIMARY security concern?',
  '[{"key":"A","text":"Lack of vendor support means no patches for new vulnerabilities"},{"key":"B","text":"The devices consume too much power"},{"key":"C","text":"The devices are physically too large"},{"key":"D","text":"The firmware uses too much storage space"}]'::jsonb,
  'A',
  'End-of-life (EOL) devices no longer receive security updates from the manufacturer, meaning newly discovered vulnerabilities will never be patched. This creates a growing security risk as exploits become available with no remediation path. Power consumption, physical size, and storage are operational concerns, not security-critical issues.',
  'medium',
  ARRAY['asset-management','end-of-life','firmware','patch-management','obj-4.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

-- ─── 4.3 Explain various activities associated with vulnerability management ─

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A vulnerability scanner reports a critical finding on a server, but upon manual investigation, the security team determines the vulnerability does not actually exist. What is this called?',
  '[{"key":"A","text":"True positive"},{"key":"B","text":"False positive"},{"key":"C","text":"True negative"},{"key":"D","text":"False negative"}]'::jsonb,
  'B',
  'A false positive occurs when a scanner incorrectly reports a vulnerability that does not actually exist. A true positive correctly identifies a real vulnerability, a true negative correctly reports no vulnerability, and a false negative fails to detect an actual vulnerability (the most dangerous outcome).',
  'easy',
  ARRAY['vulnerability-management','false-positive','scanning','obj-4.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security team uses CVSS scores to determine which vulnerabilities to patch first. A vulnerability scores 9.8 out of 10. What does this score indicate?',
  '[{"key":"A","text":"Low severity — can be addressed during routine maintenance"},{"key":"B","text":"Medium severity — should be patched within 30 days"},{"key":"C","text":"High severity — should be patched within 7 days"},{"key":"D","text":"Critical severity — requires immediate remediation"}]'::jsonb,
  'D',
  'The Common Vulnerability Scoring System (CVSS) rates vulnerabilities from 0 to 10. A score of 9.8 falls in the Critical range (9.0-10.0), indicating a vulnerability that is easy to exploit, requires no authentication, and can lead to full system compromise. Critical vulnerabilities demand immediate attention and remediation.',
  'medium',
  ARRAY['vulnerability-management','cvss','prioritization','obj-4.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'After patching a critical vulnerability, the security team runs another vulnerability scan to confirm the fix was effective. What is this step called?',
  '[{"key":"A","text":"Risk assessment"},{"key":"B","text":"Validation of remediation"},{"key":"C","text":"Threat hunting"},{"key":"D","text":"Incident response"}]'::jsonb,
  'B',
  'Validation of remediation involves rescanning or auditing a system after a fix has been applied to confirm the vulnerability has been successfully resolved. This is a critical step in the vulnerability management lifecycle. Risk assessment evaluates overall risk, threat hunting proactively looks for threats, and incident response handles active security events.',
  'medium',
  ARRAY['vulnerability-management','validation','rescanning','obj-4.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

-- ─── 4.4 Explain security alerting and monitoring concepts and tools ─────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security team wants to monitor network traffic patterns and identify unusual bandwidth usage. Which tool provides flow-based traffic analysis?',
  '[{"key":"A","text":"SIEM"},{"key":"B","text":"DLP"},{"key":"C","text":"NetFlow"},{"key":"D","text":"Antivirus"}]'::jsonb,
  'C',
  'NetFlow (and similar protocols like sFlow and IPFIX) collects and analyzes network traffic flow data, showing communication patterns, bandwidth usage, and traffic volumes between hosts. SIEM aggregates and correlates log data from multiple sources, DLP prevents data leakage, and antivirus detects malware on endpoints.',
  'medium',
  ARRAY['monitoring','netflow','network-analysis','obj-4.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization collects logs from firewalls, servers, and applications into a centralized platform that correlates events and generates alerts. Which technology is being described?',
  '[{"key":"A","text":"EDR"},{"key":"B","text":"SIEM"},{"key":"C","text":"SNMP"},{"key":"D","text":"SCAP"}]'::jsonb,
  'B',
  'A Security Information and Event Management (SIEM) system collects, aggregates, and correlates log data from multiple sources to detect threats, generate alerts, and support compliance reporting. EDR focuses on endpoint detection and response, SNMP monitors network device health, and SCAP automates vulnerability management and security configuration checks.',
  'easy',
  ARRAY['monitoring','siem','log-aggregation','obj-4.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security system generates too many alerts, most of which are not real threats, causing analysts to miss genuine security events. What is this problem called?',
  '[{"key":"A","text":"Alert fatigue"},{"key":"B","text":"False negative"},{"key":"C","text":"Scope creep"},{"key":"D","text":"Configuration drift"}]'::jsonb,
  'A',
  'Alert fatigue occurs when security analysts are overwhelmed by a high volume of alerts, many of which are false positives, leading them to ignore or miss genuine threats. The solution is alert tuning — refining rules and thresholds to reduce noise. A false negative is a missed detection, scope creep is uncontrolled project expansion, and configuration drift is systems deviating from their baseline.',
  'medium',
  ARRAY['monitoring','alert-fatigue','alert-tuning','obj-4.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

-- ─── 4.5 Given a scenario, modify enterprise capabilities to enhance security ─

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization configures its email server to verify that incoming emails originate from authorized mail servers for the sender''s domain. Which email authentication protocol does this?',
  '[{"key":"A","text":"DKIM"},{"key":"B","text":"SPF"},{"key":"C","text":"DMARC"},{"key":"D","text":"S/MIME"}]'::jsonb,
  'B',
  'Sender Policy Framework (SPF) allows domain owners to specify which mail servers are authorized to send email on behalf of their domain. Receiving servers check the SPF record to verify the sender. DKIM uses digital signatures to verify message integrity, DMARC combines SPF and DKIM with reporting, and S/MIME encrypts and digitally signs individual email messages.',
  'medium',
  ARRAY['email-security','spf','authentication','obj-4.5']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security solution monitors endpoints for suspicious behavior, can automatically isolate compromised devices, and provides investigation tools for threat analysis. What is this solution?',
  '[{"key":"A","text":"Antivirus"},{"key":"B","text":"DLP"},{"key":"C","text":"EDR (Endpoint Detection and Response)"},{"key":"D","text":"NAC"}]'::jsonb,
  'C',
  'Endpoint Detection and Response (EDR) continuously monitors endpoints for suspicious activity, provides automated response capabilities (like isolating a device), and includes investigation tools for security analysts. Traditional antivirus relies primarily on signatures, DLP prevents data exfiltration, and NAC controls network access based on device compliance.',
  'medium',
  ARRAY['edr','endpoint-security','threat-detection','obj-4.5']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A company wants to prevent employees from sending sensitive customer data via email or uploading it to personal cloud storage. Which security solution should they implement?',
  '[{"key":"A","text":"IDS/IPS"},{"key":"B","text":"Data Loss Prevention (DLP)"},{"key":"C","text":"Web application firewall"},{"key":"D","text":"File integrity monitoring"}]'::jsonb,
  'B',
  'Data Loss Prevention (DLP) solutions monitor, detect, and prevent unauthorized transmission of sensitive data. They can inspect email, web uploads, USB transfers, and other channels to enforce data handling policies. IDS/IPS detects network intrusions, WAF protects web applications, and file integrity monitoring detects unauthorized changes to files.',
  'easy',
  ARRAY['dlp','data-protection','email-security','obj-4.5']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An IDS is configured to detect attacks based on known patterns in network traffic. What detection method is this?',
  '[{"key":"A","text":"Anomaly-based detection"},{"key":"B","text":"Signature-based detection"},{"key":"C","text":"Heuristic detection"},{"key":"D","text":"Behavioral analysis"}]'::jsonb,
  'B',
  'Signature-based detection compares network traffic or system activity against a database of known attack patterns (signatures). It is effective against known threats but cannot detect novel or zero-day attacks. Anomaly-based detection establishes a baseline and flags deviations, heuristic detection uses rules to identify suspicious behavior, and behavioral analysis monitors for unusual patterns over time.',
  'easy',
  ARRAY['ids','ips','signature-based','detection','obj-4.5']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

-- ─── 4.6 Given a scenario, implement and maintain identity and access management ─

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A company implements a system where employees log in once and gain access to multiple applications without re-entering credentials. What is this called?',
  '[{"key":"A","text":"Multi-factor authentication"},{"key":"B","text":"Single sign-on (SSO)"},{"key":"C","text":"Federation"},{"key":"D","text":"Privileged access management"}]'::jsonb,
  'B',
  'Single sign-on (SSO) allows users to authenticate once and access multiple applications or services without re-authenticating. MFA requires multiple authentication factors for a single login, federation enables SSO across organizational boundaries using trust relationships, and PAM manages and monitors privileged account access.',
  'easy',
  ARRAY['iam','sso','authentication','obj-4.6']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An access control system grants permissions based on a user''s job title, department, and project assignment rather than their individual identity. Which access control model is this?',
  '[{"key":"A","text":"Discretionary Access Control (DAC)"},{"key":"B","text":"Mandatory Access Control (MAC)"},{"key":"C","text":"Attribute-Based Access Control (ABAC)"},{"key":"D","text":"Role-Based Access Control (RBAC)"}]'::jsonb,
  'C',
  'Attribute-Based Access Control (ABAC) makes access decisions based on attributes of the user (job title, department), the resource, and the environment (time of day, location). While RBAC uses predefined roles, ABAC is more granular and can combine multiple attributes. DAC lets owners set permissions, and MAC uses security labels enforced by the system.',
  'hard',
  ARRAY['iam','abac','access-control','obj-4.6']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security administrator grants a contractor temporary elevated privileges that automatically expire after 4 hours. Which privileged access management concept is this?',
  '[{"key":"A","text":"Password vaulting"},{"key":"B","text":"Just-in-time permissions"},{"key":"C","text":"Ephemeral credentials"},{"key":"D","text":"Least privilege"}]'::jsonb,
  'B',
  'Just-in-time (JIT) permissions grant elevated access only when needed and for a limited duration, after which they are automatically revoked. This reduces the window of exposure for privileged accounts. Password vaulting securely stores credentials, ephemeral credentials are short-lived access tokens, and least privilege is the broader principle of minimal access.',
  'medium',
  ARRAY['iam','pam','just-in-time','privileged-access','obj-4.6']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Which authentication protocol is an open standard commonly used to allow third-party applications to access user resources without sharing the user''s password?',
  '[{"key":"A","text":"LDAP"},{"key":"B","text":"SAML"},{"key":"C","text":"OAuth"},{"key":"D","text":"Kerberos"}]'::jsonb,
  'C',
  'OAuth (Open Authorization) is a token-based authorization framework that allows third-party applications to access user resources without exposing the user''s credentials. LDAP is a directory service protocol for querying user information, SAML is used for SSO authentication between domains, and Kerberos is a ticket-based authentication protocol used in Active Directory environments.',
  'medium',
  ARRAY['iam','oauth','authorization','protocols','obj-4.6']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

-- ─── 4.7 Explain importance of automation and orchestration ─────────────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization uses scripts to automatically create user accounts, assign permissions, and configure email when a new employee is onboarded. Which automation use case is this?',
  '[{"key":"A","text":"Guard rails"},{"key":"B","text":"User provisioning"},{"key":"C","text":"Ticket creation"},{"key":"D","text":"Continuous integration"}]'::jsonb,
  'B',
  'User provisioning automates the creation and configuration of user accounts, permissions, and resources for new employees. This ensures consistency, reduces manual errors, and speeds up onboarding. Guard rails are automated policy enforcements, ticket creation automates help desk requests, and continuous integration automates code building and testing.',
  'easy',
  ARRAY['automation','user-provisioning','orchestration','obj-4.7']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Which of the following is a key BENEFIT of using automation for security operations?',
  '[{"key":"A","text":"It eliminates the need for a security team entirely"},{"key":"B","text":"It reduces reaction time and enforces consistent baselines"},{"key":"C","text":"It guarantees zero false positives"},{"key":"D","text":"It replaces the need for security policies"}]'::jsonb,
  'B',
  'Automation in security operations reduces reaction time (responding to threats in seconds vs. hours), enforces consistent security baselines across all systems, and acts as a workforce multiplier. It does not eliminate the need for human analysts, cannot guarantee zero false positives, and complements rather than replaces security policies.',
  'medium',
  ARRAY['automation','benefits','security-operations','obj-4.7']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A company relies entirely on a single automation platform for all security responses. If that platform goes down, no automated responses occur. What risk does this represent?',
  '[{"key":"A","text":"Technical debt"},{"key":"B","text":"Single point of failure"},{"key":"C","text":"Complexity"},{"key":"D","text":"Ongoing supportability"}]'::jsonb,
  'B',
  'A single point of failure (SPOF) exists when one component''s failure can disable an entire system or process. If all security automation depends on a single platform, its outage leaves the organization without automated defenses. Technical debt is accumulated shortcuts in code, complexity refers to difficulty managing systems, and supportability concerns long-term maintenance.',
  'medium',
  ARRAY['automation','single-point-of-failure','risk','obj-4.7']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

-- ─── 4.8 Explain appropriate incident response activities ───────────────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'During a security investigation, a forensic analyst creates a bit-for-bit copy of a hard drive and documents a hash of the original and copy. Which forensic concept ensures the evidence is admissible in court?',
  '[{"key":"A","text":"Root cause analysis"},{"key":"B","text":"Chain of custody"},{"key":"C","text":"E-discovery"},{"key":"D","text":"Threat hunting"}]'::jsonb,
  'B',
  'Chain of custody documents every person who handled the evidence, when they handled it, and what they did with it. Maintaining chain of custody with verified hashes ensures evidence integrity and admissibility in court. Root cause analysis identifies why an incident occurred, e-discovery is the process of finding electronic evidence for legal proceedings, and threat hunting proactively searches for threats.',
  'medium',
  ARRAY['incident-response','chain-of-custody','forensics','obj-4.8']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'After containing a ransomware attack, the security team completely removes the malware and restores affected systems from clean backups. Which incident response phase is this?',
  '[{"key":"A","text":"Detection"},{"key":"B","text":"Containment"},{"key":"C","text":"Eradication"},{"key":"D","text":"Lessons learned"}]'::jsonb,
  'C',
  'Eradication is the phase where the threat is completely removed from the environment — deleting malware, closing exploited vulnerabilities, and cleaning affected systems. This follows containment (isolating the threat) and precedes recovery (restoring normal operations). Detection identifies the incident, and lessons learned is the final phase where the team reviews what happened.',
  'medium',
  ARRAY['incident-response','eradication','ransomware','obj-4.8']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security analyst proactively searches through network logs and endpoint data looking for signs of compromise that automated tools may have missed. What is this activity called?',
  '[{"key":"A","text":"Vulnerability scanning"},{"key":"B","text":"Penetration testing"},{"key":"C","text":"Threat hunting"},{"key":"D","text":"Log aggregation"}]'::jsonb,
  'C',
  'Threat hunting is the proactive search for threats that may have evaded existing security controls. Hunters use hypotheses, intelligence, and manual analysis to find indicators of compromise in data that automated systems missed. Vulnerability scanning identifies known weaknesses, penetration testing exploits them, and log aggregation collects data but doesn''t actively search for threats.',
  'medium',
  ARRAY['incident-response','threat-hunting','proactive-security','obj-4.8']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

-- ─── 4.9 Given a scenario, use data sources to support an investigation ─────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'During a security investigation, an analyst needs to determine which external IP addresses a compromised server communicated with. Which data source would be MOST useful?',
  '[{"key":"A","text":"Application logs"},{"key":"B","text":"Firewall logs"},{"key":"C","text":"OS security logs"},{"key":"D","text":"Endpoint logs"}]'::jsonb,
  'B',
  'Firewall logs record all network connections including source and destination IP addresses, ports, and whether traffic was allowed or blocked. They are the most direct source for identifying external communications from a compromised server. Application logs show application-level events, OS security logs track authentication and system events, and endpoint logs monitor device-level activity.',
  'medium',
  ARRAY['investigation','firewall-logs','data-sources','obj-4.9']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security analyst captures raw network traffic between a client and server to analyze the exact data being exchanged during a suspected data exfiltration. What technique is being used?',
  '[{"key":"A","text":"Log aggregation"},{"key":"B","text":"Packet capture"},{"key":"C","text":"Vulnerability scanning"},{"key":"D","text":"NetFlow analysis"}]'::jsonb,
  'B',
  'Packet capture (PCAP) records the full content of network traffic, allowing analysts to reconstruct conversations and examine the exact data transmitted. This is the most detailed form of network analysis. Log aggregation collects event records, vulnerability scanning finds weaknesses, and NetFlow provides traffic flow summaries without payload content.',
  'easy',
  ARRAY['investigation','packet-capture','pcap','network-analysis','obj-4.9']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';
