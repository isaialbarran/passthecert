-- Domain 4.0: Security Operations — Batch 2 (51 questions)
-- Objectives: 4.1-4.9
-- Topics: SOAR, forensics, legal hold, DKIM/DMARC, MFA, PAM, SAML, scripting, CIS benchmarks

-- ─── 4.1 Apply common security techniques to computing resources ────────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security team needs to test a suspicious email attachment in an isolated environment before allowing it on the network. Which technique should they use?',
  '[{"key":"A","text":"Static code analysis"},{"key":"B","text":"Sandboxing"},{"key":"C","text":"Hashing"},{"key":"D","text":"Data masking"}]'::jsonb,
  'B',
  'Sandboxing executes suspicious files in an isolated virtual environment to observe their behavior without risking the production network. Static code analysis reviews source code without execution, hashing verifies file integrity, and data masking obscures sensitive information.',
  'easy',
  ARRAY['sandboxing','malware-analysis','isolation','obj-4.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization uses a tool that sends random, malformed inputs to an application to identify crashes and unexpected behavior. What type of testing is this?',
  '[{"key":"A","text":"Static analysis"},{"key":"B","text":"Regression testing"},{"key":"C","text":"Fuzzing"},{"key":"D","text":"Code review"}]'::jsonb,
  'C',
  'Fuzzing (dynamic analysis) sends random, malformed, or unexpected inputs to a running application to discover vulnerabilities like buffer overflows and input handling errors. Static analysis examines code without execution, regression testing verifies that changes don''t break existing features, and code review is a manual examination of source code.',
  'medium',
  ARRAY['fuzzing','dynamic-analysis','application-security','obj-4.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An administrator applies CIS Benchmarks to all new servers before deployment. What is the PRIMARY purpose of this practice?',
  '[{"key":"A","text":"To monitor server performance"},{"key":"B","text":"To establish a secure configuration baseline"},{"key":"C","text":"To encrypt data at rest"},{"key":"D","text":"To create system backups"}]'::jsonb,
  'B',
  'CIS Benchmarks provide industry-accepted secure configuration guidelines that establish a hardened baseline for systems before deployment. They reduce the attack surface by disabling unnecessary services and enforcing security settings. Performance monitoring, encryption, and backups are separate security concerns.',
  'medium',
  ARRAY['hardening','cis-benchmarks','secure-baseline','obj-4.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A Linux administrator configures a mandatory access control system that confines applications to a limited set of resources based on security profiles. Which tool is MOST likely being used?',
  '[{"key":"A","text":"iptables"},{"key":"B","text":"AppArmor"},{"key":"C","text":"chmod"},{"key":"D","text":"sudo"}]'::jsonb,
  'B',
  'AppArmor is a Linux mandatory access control framework that restricts programs'' capabilities through security profiles, limiting what files and resources they can access. iptables is a firewall tool, chmod changes file permissions (discretionary access control), and sudo grants temporary elevated privileges.',
  'hard',
  ARRAY['linux-security','apparmor','mandatory-access-control','obj-4.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A Windows administrator uses Group Policy Objects to enforce screen lock after 5 minutes of inactivity across all workstations. Which security concept does this enforce?',
  '[{"key":"A","text":"Least privilege"},{"key":"B","text":"Configuration management"},{"key":"C","text":"Incident response"},{"key":"D","text":"Data classification"}]'::jsonb,
  'B',
  'Group Policy Objects (GPOs) are a configuration management tool that enforces consistent security settings across Windows endpoints. Enforcing screen lock timeouts through GPO ensures all workstations meet the organization''s security baseline. Least privilege limits access rights, incident response handles security events, and data classification categorizes information sensitivity.',
  'easy',
  ARRAY['gpo','group-policy','configuration-management','obj-4.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security tool continuously monitors critical system files and alerts when unauthorized changes are detected. What type of solution is this?',
  '[{"key":"A","text":"DLP"},{"key":"B","text":"SIEM"},{"key":"C","text":"FIM (File Integrity Monitoring)"},{"key":"D","text":"NAC"}]'::jsonb,
  'C',
  'File Integrity Monitoring (FIM) tracks changes to critical files, directories, and registry keys, alerting administrators when unauthorized modifications occur. DLP prevents data exfiltration, SIEM aggregates and correlates logs from multiple sources, and NAC controls network device access.',
  'easy',
  ARRAY['fim','file-integrity-monitoring','detection','obj-4.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

-- ─── 4.2 Asset management security implications ────────────────────────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization discovers a web application running on a server that no team claims ownership of. This server was not in the asset inventory. What does this represent?',
  '[{"key":"A","text":"Shadow IT"},{"key":"B","text":"Configuration drift"},{"key":"C","text":"Technical debt"},{"key":"D","text":"Scope creep"}]'::jsonb,
  'A',
  'Shadow IT refers to unauthorized systems, applications, or services deployed without IT department knowledge or approval. An untracked server running an unknown web application is a classic example. Configuration drift is when systems deviate from baseline, technical debt is accumulated shortcuts, and scope creep is uncontrolled project expansion.',
  'medium',
  ARRAY['shadow-it','asset-management','risk','obj-4.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A company policy requires that all hard drives be physically shredded before disposal. Which data sanitization method does this represent?',
  '[{"key":"A","text":"Purging"},{"key":"B","text":"Clearing"},{"key":"C","text":"Destruction"},{"key":"D","text":"Degaussing"}]'::jsonb,
  'C',
  'Destruction is the physical demolition of storage media (shredding, incineration, pulverizing) making data recovery impossible. Purging uses advanced techniques like cryptographic erasure to render data unrecoverable, clearing overwrites data with patterns, and degaussing uses magnetic fields to erase magnetic media.',
  'easy',
  ARRAY['data-sanitization','destruction','asset-lifecycle','obj-4.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

-- ─── 4.3 Vulnerability management ──────────────────────────────────────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A vulnerability scan using administrator credentials finds 30 more vulnerabilities than a scan without credentials on the same server. Why?',
  '[{"key":"A","text":"The credentialed scan generated false positives"},{"key":"B","text":"Credentialed scans can inspect internal configurations and installed software"},{"key":"C","text":"The non-credentialed scan was blocked by the firewall"},{"key":"D","text":"Credentialed scans use more aggressive exploit techniques"}]'::jsonb,
  'B',
  'Credentialed (authenticated) scans log into the target system and can inspect installed patches, configurations, file permissions, and local services — revealing vulnerabilities invisible to external probes. Non-credentialed scans only see what is externally exposed. The additional findings are likely true positives, not false positives. Credentialed scans do not use exploits.',
  'medium',
  ARRAY['vulnerability-scanning','credentialed','assessment','obj-4.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Two vulnerabilities have the same CVSS score of 7.5. One affects a public-facing payment server, the other affects an internal test server. How should the security team prioritize?',
  '[{"key":"A","text":"Patch both simultaneously since they have the same score"},{"key":"B","text":"Prioritize the payment server based on asset criticality and exposure"},{"key":"C","text":"Prioritize the test server since it is easier to patch"},{"key":"D","text":"Ignore both since 7.5 is not critical severity"}]'::jsonb,
  'B',
  'Vulnerability prioritization should consider CVSS score plus business context: asset criticality, data sensitivity, and exposure level. A public-facing payment server has higher business impact and attack surface than an internal test server. A score of 7.5 is high severity and should not be ignored. Ease of patching is a factor but not the primary driver.',
  'hard',
  ARRAY['vulnerability-management','prioritization','risk-context','obj-4.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization establishes a process where patches are tested in a staging environment, approved by change management, and then deployed to production on a schedule. What is this called?',
  '[{"key":"A","text":"Incident response"},{"key":"B","text":"Patch management lifecycle"},{"key":"C","text":"Vulnerability scanning"},{"key":"D","text":"Configuration drift"}]'::jsonb,
  'B',
  'The patch management lifecycle includes identifying patches, testing them in a non-production environment, obtaining change management approval, deploying to production, and validating success. Incident response handles active threats, vulnerability scanning identifies weaknesses, and configuration drift is unintended system changes.',
  'easy',
  ARRAY['patch-management','lifecycle','change-management','obj-4.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization invites external security researchers to find and report vulnerabilities in exchange for monetary rewards. What is this program called?',
  '[{"key":"A","text":"Penetration test"},{"key":"B","text":"Red team exercise"},{"key":"C","text":"Bug bounty program"},{"key":"D","text":"Vulnerability assessment"}]'::jsonb,
  'C',
  'A bug bounty program offers financial rewards to external researchers who discover and responsibly disclose vulnerabilities. Unlike penetration tests, bug bounties are ongoing and open to many participants. Red team exercises simulate adversary attacks internally, and vulnerability assessments use automated scanning to identify weaknesses.',
  'easy',
  ARRAY['bug-bounty','vulnerability-disclosure','assessment','obj-4.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

-- ─── 4.4 Security alerting and monitoring ──────────────────────────────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security analyst configures systems to forward all log data to a central server using a standardized protocol on UDP port 514. Which protocol is being used?',
  '[{"key":"A","text":"SNMP"},{"key":"B","text":"Syslog"},{"key":"C","text":"NetFlow"},{"key":"D","text":"SMTP"}]'::jsonb,
  'B',
  'Syslog is the standard protocol for log message forwarding, typically using UDP port 514 (or TCP 514 / TLS on port 6514 for secure transmission). SNMP monitors device health on ports 161/162, NetFlow provides traffic flow data, and SMTP is for email transmission on port 25.',
  'easy',
  ARRAY['syslog','logging','monitoring','obj-4.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An IDS detects unusual patterns by comparing current behavior against an established normal activity profile. What detection method is this?',
  '[{"key":"A","text":"Signature-based"},{"key":"B","text":"Anomaly-based"},{"key":"C","text":"Heuristic"},{"key":"D","text":"Rule-based"}]'::jsonb,
  'B',
  'Anomaly-based detection establishes a baseline of normal behavior and alerts when activity deviates from that baseline. It can detect unknown (zero-day) threats but may produce more false positives. Signature-based compares against known attack patterns, heuristic uses rules to identify suspicious behavior, and rule-based triggers on predefined conditions.',
  'medium',
  ARRAY['ids','anomaly-based','detection','monitoring','obj-4.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A network administrator uses a protocol to query device status, CPU load, and interface statistics from routers and switches. Which protocol is this?',
  '[{"key":"A","text":"Syslog"},{"key":"B","text":"SNMP"},{"key":"C","text":"LDAP"},{"key":"D","text":"SSH"}]'::jsonb,
  'B',
  'Simple Network Management Protocol (SNMP) queries network devices for operational data including device status, CPU load, memory usage, and interface statistics. Syslog forwards log messages, LDAP queries directory services for user information, and SSH provides secure remote access.',
  'easy',
  ARRAY['snmp','monitoring','network-management','obj-4.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization requires that all security logs be retained for a minimum of one year to meet regulatory requirements. Which concept does this represent?',
  '[{"key":"A","text":"Log aggregation"},{"key":"B","text":"Data retention policy"},{"key":"C","text":"Chain of custody"},{"key":"D","text":"Continuous monitoring"}]'::jsonb,
  'B',
  'A data retention policy defines how long different types of data must be stored before they can be deleted, often driven by regulatory or compliance requirements. Log aggregation is collecting logs centrally, chain of custody tracks evidence handling, and continuous monitoring is ongoing security surveillance.',
  'easy',
  ARRAY['data-retention','logging','compliance','obj-4.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security analyst investigates a Windows server and needs to review authentication failures and account lockouts. Which log source should they check FIRST?',
  '[{"key":"A","text":"Application log"},{"key":"B","text":"System log"},{"key":"C","text":"Security log"},{"key":"D","text":"Setup log"}]'::jsonb,
  'C',
  'The Windows Security log records authentication events, including successful and failed logins, account lockouts, and privilege use. The Application log captures application-specific events, the System log records OS events like driver failures, and the Setup log tracks installation activities.',
  'medium',
  ARRAY['windows-logs','security-log','investigation','obj-4.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

-- ─── 4.5 Modify enterprise capabilities to enhance security ────────────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization wants to verify that email content has not been altered in transit by checking a cryptographic signature added by the sending server. Which protocol does this?',
  '[{"key":"A","text":"SPF"},{"key":"B","text":"DKIM"},{"key":"C","text":"DMARC"},{"key":"D","text":"TLS"}]'::jsonb,
  'B',
  'DomainKeys Identified Mail (DKIM) adds a digital signature to outgoing emails that the receiving server verifies, ensuring message integrity. SPF validates the sending server''s IP address, DMARC combines SPF and DKIM with policy enforcement, and TLS encrypts the transport channel but doesn''t sign individual messages.',
  'medium',
  ARRAY['email-security','dkim','integrity','obj-4.5']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A domain owner configures a DNS record that tells receiving mail servers to reject emails failing both SPF and DKIM checks, and to send aggregate reports. Which protocol is this?',
  '[{"key":"A","text":"DNSSEC"},{"key":"B","text":"S/MIME"},{"key":"C","text":"DMARC"},{"key":"D","text":"MX record"}]'::jsonb,
  'C',
  'DMARC (Domain-based Message Authentication, Reporting, and Conformance) tells receiving servers what to do when SPF and DKIM checks fail (none, quarantine, or reject) and provides reporting. DNSSEC validates DNS responses, S/MIME encrypts individual email content, and MX records specify mail server addresses.',
  'medium',
  ARRAY['email-security','dmarc','authentication','obj-4.5']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A company''s SSL/TLS certificate is about to expire in 30 days. The security team initiates the renewal process. Which phase of the certificate lifecycle is this?',
  '[{"key":"A","text":"Issuance"},{"key":"B","text":"Renewal"},{"key":"C","text":"Revocation"},{"key":"D","text":"Suspension"}]'::jsonb,
  'B',
  'Certificate renewal is the process of obtaining a new certificate before the current one expires, maintaining uninterrupted encrypted communications. Issuance is the initial creation of the certificate, revocation permanently invalidates a certificate before expiry (e.g., if the private key is compromised), and suspension temporarily disables a certificate.',
  'easy',
  ARRAY['certificate-lifecycle','renewal','pki','obj-4.5']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

-- ─── 4.6 Identity and access management ────────────────────────────────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A company assigns access permissions based on job titles: all "Accountants" get access to the financial system, all "Engineers" get access to the code repository. Which access control model is this?',
  '[{"key":"A","text":"DAC"},{"key":"B","text":"MAC"},{"key":"C","text":"RBAC"},{"key":"D","text":"ABAC"}]'::jsonb,
  'C',
  'Role-Based Access Control (RBAC) assigns permissions to roles (job titles or functions) rather than individual users. Users inherit permissions by being assigned to roles. DAC lets resource owners set permissions, MAC uses security labels enforced by the system, and ABAC evaluates multiple attributes (department, time, location) for access decisions.',
  'easy',
  ARRAY['iam','rbac','access-control','obj-4.6']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A user logs into their company portal and is then able to access email, HR systems, and the CRM without re-authenticating. The company and CRM provider have established a trust relationship. What enables this?',
  '[{"key":"A","text":"OAuth"},{"key":"B","text":"SAML"},{"key":"C","text":"LDAP"},{"key":"D","text":"RADIUS"}]'::jsonb,
  'B',
  'Security Assertion Markup Language (SAML) enables federated SSO by exchanging authentication assertions between an identity provider (company) and service providers (CRM) based on a trust relationship. OAuth is primarily for authorization/API access, LDAP is a directory service protocol, and RADIUS handles network authentication (typically for Wi-Fi/VPN).',
  'medium',
  ARRAY['iam','saml','federation','sso','obj-4.6']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A user authenticates using a password and then a push notification sent to their smartphone. Which authentication concept is being applied?',
  '[{"key":"A","text":"Single-factor authentication"},{"key":"B","text":"Multi-factor authentication"},{"key":"C","text":"Single sign-on"},{"key":"D","text":"Passwordless authentication"}]'::jsonb,
  'B',
  'Multi-factor authentication (MFA) requires two or more different authentication factors: something you know (password) and something you have (smartphone receiving the push). Single-factor uses only one factor, SSO allows access to multiple apps with one login, and passwordless eliminates passwords entirely (using biometrics or hardware keys).',
  'easy',
  ARRAY['iam','mfa','authentication','obj-4.6']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization replaces passwords entirely with FIDO2-compliant hardware security keys for all employee logins. What type of authentication is this?',
  '[{"key":"A","text":"Biometric authentication"},{"key":"B","text":"Certificate-based authentication"},{"key":"C","text":"Passwordless authentication"},{"key":"D","text":"Token-based authentication"}]'::jsonb,
  'C',
  'Passwordless authentication eliminates passwords by using alternatives like FIDO2 hardware keys, biometrics, or passkeys. While FIDO2 keys are technically hardware tokens, the defining characteristic is the removal of passwords from the authentication flow. Biometric uses physical characteristics, certificate-based uses X.509 certificates, and token-based is a broader category.',
  'medium',
  ARRAY['iam','passwordless','fido2','authentication','obj-4.6']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A PAM solution automatically rotates privileged account passwords, stores them in an encrypted vault, and records all administrative sessions. Which capability is the PRIMARY security benefit?',
  '[{"key":"A","text":"It eliminates the need for privileged accounts"},{"key":"B","text":"It reduces the risk of stolen credentials and provides audit trails"},{"key":"C","text":"It replaces MFA for administrators"},{"key":"D","text":"It prevents all insider threats"}]'::jsonb,
  'B',
  'Privileged Access Management (PAM) solutions reduce credential theft risk through automated password rotation and secure vaulting, while session recording provides accountability and audit trails. PAM does not eliminate privileged accounts, replace MFA, or prevent all insider threats — it manages and monitors privileged access.',
  'medium',
  ARRAY['iam','pam','password-vaulting','session-recording','obj-4.6']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A company uses a protocol that authenticates users connecting to Wi-Fi by verifying credentials against a central authentication server. Which protocol provides this functionality?',
  '[{"key":"A","text":"LDAP"},{"key":"B","text":"RADIUS"},{"key":"C","text":"Kerberos"},{"key":"D","text":"SAML"}]'::jsonb,
  'B',
  'RADIUS (Remote Authentication Dial-In User Service) provides centralized authentication for network access, commonly used for Wi-Fi (802.1X), VPN, and remote connections. LDAP is a directory service for querying user information, Kerberos is a ticket-based protocol used in Active Directory, and SAML enables web-based federated SSO.',
  'medium',
  ARRAY['iam','radius','network-authentication','wireless','obj-4.6']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization uses a ticket-based authentication protocol where users receive a Ticket Granting Ticket (TGT) after initial authentication, then use it to request access to services. Which protocol is this?',
  '[{"key":"A","text":"RADIUS"},{"key":"B","text":"OAuth"},{"key":"C","text":"Kerberos"},{"key":"D","text":"TACACS+"}]'::jsonb,
  'C',
  'Kerberos uses a Key Distribution Center (KDC) to issue Ticket Granting Tickets (TGTs) after initial authentication. Users present TGTs to request service tickets for accessing specific resources, enabling SSO within the domain. RADIUS centralizes network authentication, OAuth delegates authorization, and TACACS+ handles device administration authentication.',
  'medium',
  ARRAY['iam','kerberos','authentication','active-directory','obj-4.6']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'What is the key difference between RADIUS and TACACS+?',
  '[{"key":"A","text":"RADIUS encrypts the entire packet while TACACS+ only encrypts the password"},{"key":"B","text":"TACACS+ encrypts the entire packet while RADIUS only encrypts the password"},{"key":"C","text":"RADIUS uses TCP while TACACS+ uses UDP"},{"key":"D","text":"TACACS+ is only used for wireless authentication"}]'::jsonb,
  'B',
  'TACACS+ encrypts the entire authentication packet for better security, while RADIUS only encrypts the password field. Additionally, TACACS+ uses TCP (port 49) for reliable delivery, while RADIUS uses UDP (ports 1812/1813). TACACS+ is commonly used for device administration, not just wireless.',
  'hard',
  ARRAY['iam','radius','tacacs','comparison','obj-4.6']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'When an employee leaves the organization, their accounts are disabled, access badges are deactivated, and devices are collected. Which IAM process is this?',
  '[{"key":"A","text":"Provisioning"},{"key":"B","text":"Deprovisioning"},{"key":"C","text":"Attestation"},{"key":"D","text":"Recertification"}]'::jsonb,
  'B',
  'Deprovisioning (offboarding) is the process of revoking all access when a user leaves the organization — disabling accounts, removing permissions, recovering devices, and deactivating physical access. Provisioning grants access for new users, attestation verifies access is still appropriate, and recertification is periodic review of access rights.',
  'easy',
  ARRAY['iam','deprovisioning','offboarding','account-lifecycle','obj-4.6']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A web application uses automated scripts, and these scripts need database access. The security team creates a dedicated account with only the required permissions. What type of account is this?',
  '[{"key":"A","text":"Guest account"},{"key":"B","text":"Shared account"},{"key":"C","text":"Service account"},{"key":"D","text":"Privileged account"}]'::jsonb,
  'C',
  'A service account is a dedicated account used by applications, scripts, or services rather than human users. It should follow least privilege with only the permissions required for its function. Guest accounts provide temporary limited access, shared accounts are used by multiple people (discouraged), and privileged accounts have elevated administrative rights.',
  'easy',
  ARRAY['iam','service-account','account-types','obj-4.6']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An access policy allows employees to connect to the VPN only during business hours and only from devices within the country. What type of access control is this?',
  '[{"key":"A","text":"Role-based access control"},{"key":"B","text":"Conditional access policy"},{"key":"C","text":"Mandatory access control"},{"key":"D","text":"Discretionary access control"}]'::jsonb,
  'B',
  'Conditional access policies evaluate contextual conditions (time of day, location, device compliance, risk level) before granting access. RBAC assigns permissions based on roles, MAC uses security labels, and DAC lets resource owners set permissions. Conditional access adds dynamic, context-aware controls beyond static role or label assignment.',
  'hard',
  ARRAY['iam','conditional-access','context-aware','geofencing','obj-4.6']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An administrator queries a directory service using port 389 to look up user attributes such as email address and group membership. Which protocol is being used?',
  '[{"key":"A","text":"RADIUS"},{"key":"B","text":"LDAP"},{"key":"C","text":"Kerberos"},{"key":"D","text":"SAML"}]'::jsonb,
  'B',
  'LDAP (Lightweight Directory Access Protocol) uses port 389 (or 636 for LDAPS) to query directory services for user attributes, group memberships, and organizational data. RADIUS authenticates network access, Kerberos handles ticket-based authentication, and SAML enables federated web SSO.',
  'medium',
  ARRAY['iam','ldap','directory-services','obj-4.6']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

-- ─── 4.7 Automation and orchestration ──────────────────────────────────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security platform automatically correlates alerts, enriches them with threat intelligence, and executes predefined response playbooks without manual intervention. What is this solution?',
  '[{"key":"A","text":"SIEM"},{"key":"B","text":"SOAR"},{"key":"C","text":"EDR"},{"key":"D","text":"XDR"}]'::jsonb,
  'B',
  'SOAR (Security Orchestration, Automation, and Response) integrates security tools, automates repetitive tasks, and executes response playbooks automatically. SIEM collects and correlates logs but typically requires manual response, EDR focuses on endpoint detection, and XDR extends detection across multiple security layers.',
  'medium',
  ARRAY['soar','automation','orchestration','playbooks','obj-4.7']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security engineer writes a Python script that automatically blocks IP addresses seen in threat intelligence feeds by updating firewall rules. What type of automation is this?',
  '[{"key":"A","text":"User provisioning"},{"key":"B","text":"Continuous integration"},{"key":"C","text":"Automated remediation"},{"key":"D","text":"Configuration management"}]'::jsonb,
  'C',
  'Automated remediation uses scripts or tools to automatically respond to threats — in this case, blocking malicious IPs without human intervention. User provisioning automates account creation, continuous integration automates code builds, and configuration management maintains system settings.',
  'medium',
  ARRAY['automation','remediation','scripting','threat-intelligence','obj-4.7']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security team uses a document that contains step-by-step automated procedures for common incident types, such as "phishing email detected" or "malware alert triggered." What is this document called?',
  '[{"key":"A","text":"Incident response plan"},{"key":"B","text":"Runbook"},{"key":"C","text":"Risk register"},{"key":"D","text":"Business continuity plan"}]'::jsonb,
  'B',
  'A runbook contains specific, step-by-step procedures (often automated) for handling routine operational or security tasks. It is more specific and technical than an incident response plan, which provides the overall framework. A risk register tracks identified risks, and a BCP ensures business operations continue during disruptions.',
  'medium',
  ARRAY['automation','runbook','procedures','incident-response','obj-4.7']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security team subscribes to external feeds that provide real-time data about emerging threats, malicious IP addresses, and indicators of compromise. What is this called?',
  '[{"key":"A","text":"Vulnerability scanning"},{"key":"B","text":"Threat intelligence feeds"},{"key":"C","text":"Penetration testing"},{"key":"D","text":"Log aggregation"}]'::jsonb,
  'B',
  'Threat intelligence feeds provide real-time, actionable data about current threats, including malicious IPs, domains, file hashes, and attack techniques. Vulnerability scanning identifies system weaknesses, penetration testing simulates attacks, and log aggregation collects event data from internal sources.',
  'easy',
  ARRAY['threat-intelligence','feeds','ioc','obj-4.7']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Which scripting language is MOST commonly used for automating Windows security administration tasks such as log collection, user management, and policy enforcement?',
  '[{"key":"A","text":"Bash"},{"key":"B","text":"Python"},{"key":"C","text":"PowerShell"},{"key":"D","text":"Ruby"}]'::jsonb,
  'C',
  'PowerShell is the native scripting language for Windows administration, with deep integration into Active Directory, Group Policy, and Windows security tools. Bash is the standard for Linux, Python is cross-platform and widely used in security but not Windows-native, and Ruby is primarily used in web development.',
  'easy',
  ARRAY['scripting','powershell','automation','windows','obj-4.7']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

-- ─── 4.8 Incident response activities ──────────────────────────────────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A SIEM generates an alert about unusual outbound traffic from a server at 3 AM. The security analyst confirms it is a real threat. Which incident response phase are they in?',
  '[{"key":"A","text":"Preparation"},{"key":"B","text":"Detection and analysis"},{"key":"C","text":"Containment"},{"key":"D","text":"Recovery"}]'::jsonb,
  'B',
  'The detection and analysis (identification) phase involves recognizing potential security incidents through alerts, monitoring, and analysis, then confirming whether they are real threats. Preparation occurs before any incident, containment isolates the threat after confirmation, and recovery restores normal operations.',
  'medium',
  ARRAY['incident-response','detection','analysis','obj-4.8']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'During a ransomware incident, the security team disconnects the infected server from the network but keeps it powered on to preserve volatile data. Which containment strategy is this?',
  '[{"key":"A","text":"Eradication"},{"key":"B","text":"Isolation"},{"key":"C","text":"Segmentation"},{"key":"D","text":"Recovery"}]'::jsonb,
  'B',
  'Isolation disconnects the compromised system from the network to prevent lateral movement while keeping it running to preserve volatile evidence (RAM contents, running processes). Eradication removes the threat entirely, segmentation divides networks proactively (not reactively), and recovery restores normal operations after the threat is removed.',
  'medium',
  ARRAY['incident-response','containment','isolation','forensics','obj-4.8']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'After resolving a major security incident, the team meets to document what happened, what worked, what failed, and how to improve. Which incident response phase is this?',
  '[{"key":"A","text":"Recovery"},{"key":"B","text":"Eradication"},{"key":"C","text":"Lessons learned"},{"key":"D","text":"Containment"}]'::jsonb,
  'C',
  'Lessons learned (post-incident activity) is the final phase where the team reviews the incident, documents findings, identifies improvements, and updates policies and procedures. Recovery restores normal operations, eradication removes the threat, and containment isolates it to prevent spread.',
  'easy',
  ARRAY['incident-response','lessons-learned','post-incident','obj-4.8']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'During a data breach investigation, the legal department instructs the IT team that no data related to the incident may be deleted or modified. What is this directive called?',
  '[{"key":"A","text":"Chain of custody"},{"key":"B","text":"Legal hold"},{"key":"C","text":"Data retention policy"},{"key":"D","text":"Non-disclosure agreement"}]'::jsonb,
  'B',
  'A legal hold (litigation hold) requires that all potentially relevant data be preserved and protected from modification or deletion during an investigation or legal proceeding. Chain of custody tracks evidence handling, data retention policies define normal storage durations, and NDAs protect confidential information sharing.',
  'medium',
  ARRAY['incident-response','legal-hold','e-discovery','forensics','obj-4.8']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security incident is classified as "Critical" and requires immediate notification to the CISO, legal counsel, and affected customers. What does this classification determine?',
  '[{"key":"A","text":"The type of malware involved"},{"key":"B","text":"The escalation path and communication requirements"},{"key":"C","text":"The forensic tools to use"},{"key":"D","text":"The backup restoration method"}]'::jsonb,
  'B',
  'Incident severity classification determines the escalation path, stakeholder notification requirements, response urgency, and resource allocation. It does not directly determine malware type, specific forensic tools, or backup methods — those are determined by the nature of the incident and technical requirements.',
  'hard',
  ARRAY['incident-response','classification','severity','communication','obj-4.8']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'After an incident is fully resolved, systems are restored from verified backups, patches are applied, and the team confirms normal operations. Which phase is this?',
  '[{"key":"A","text":"Containment"},{"key":"B","text":"Eradication"},{"key":"C","text":"Recovery"},{"key":"D","text":"Lessons learned"}]'::jsonb,
  'C',
  'Recovery is the phase where affected systems are restored to normal operation — rebuilding from clean backups, applying patches, verifying functionality, and monitoring for recurrence. Containment isolates the threat, eradication removes it, and lessons learned reviews the incident after full recovery.',
  'easy',
  ARRAY['incident-response','recovery','restoration','obj-4.8']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'After investigating a breach, the security team determines it was caused by an unpatched vulnerability that had a known fix available for 6 months. What should the lessons-learned report recommend?',
  '[{"key":"A","text":"Deploy more firewalls"},{"key":"B","text":"Improve the patch management process and reduce patch deployment timelines"},{"key":"C","text":"Disable all external network access"},{"key":"D","text":"Replace all affected hardware"}]'::jsonb,
  'B',
  'Root cause analysis revealed a patch management failure — a known fix was available but not applied. The corrective action should address the root cause: improving patch management processes and reducing deployment timelines. Adding firewalls addresses symptoms not root cause, disabling external access is disproportionate, and hardware replacement is unnecessary.',
  'hard',
  ARRAY['incident-response','root-cause-analysis','lessons-learned','patch-management','obj-4.8']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

-- ─── 4.9 Data sources to support investigations ────────────────────────────

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A forensic analyst needs to create an exact copy of a suspect''s hard drive while ensuring the original is not modified. Which tool should they use?',
  '[{"key":"A","text":"File copy utility"},{"key":"B","text":"Write blocker and disk imaging tool"},{"key":"C","text":"Backup software"},{"key":"D","text":"Disk defragmenter"}]'::jsonb,
  'B',
  'A write blocker prevents any modifications to the original drive while a disk imaging tool creates a bit-for-bit forensic copy (image). Regular file copy misses deleted files and slack space, backup software may skip system files, and defragmentation would alter the original drive — destroying evidence.',
  'medium',
  ARRAY['forensics','write-blocker','disk-imaging','evidence','obj-4.9']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'During a forensic investigation, which of the following data sources should be collected FIRST due to its volatility?',
  '[{"key":"A","text":"Hard drive contents"},{"key":"B","text":"RAM contents"},{"key":"C","text":"Network logs"},{"key":"D","text":"Backup tapes"}]'::jsonb,
  'B',
  'The order of volatility dictates collecting the most volatile data first. RAM contents are lost when the system is powered off, making them the highest priority. Hard drive data persists after shutdown, network logs are typically stored on separate servers, and backup tapes are the least volatile.',
  'medium',
  ARRAY['forensics','order-of-volatility','ram','evidence-collection','obj-4.9']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An investigator examines email headers to determine the true origin of a suspicious message. Which piece of metadata is MOST useful for identifying the sending server?',
  '[{"key":"A","text":"Subject line"},{"key":"B","text":"Received: header fields"},{"key":"C","text":"CC recipients"},{"key":"D","text":"Message body"}]'::jsonb,
  'B',
  'The Received: header fields are added by each mail server that handles the message, creating a traceable path from origin to destination. They reveal the actual sending server''s IP address. The subject line is user-defined and easily spoofed, CC shows recipients, and the message body contains content but not routing metadata.',
  'hard',
  ARRAY['forensics','email-headers','metadata','investigation','obj-4.9']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A forensic analyst creates a timeline showing when files were created, modified, accessed, and deleted on a compromised system. What type of analysis is this?',
  '[{"key":"A","text":"Root cause analysis"},{"key":"B","text":"Timeline analysis"},{"key":"C","text":"Vulnerability assessment"},{"key":"D","text":"Threat modeling"}]'::jsonb,
  'B',
  'Timeline analysis reconstructs the sequence of events on a system by correlating file timestamps (created, modified, accessed), log entries, and other artifacts to understand what happened and when. Root cause analysis identifies why an incident occurred, vulnerability assessment finds weaknesses, and threat modeling identifies potential threats.',
  'medium',
  ARRAY['forensics','timeline-analysis','investigation','obj-4.9']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A penetration test report includes the scope, methodology, vulnerabilities found, exploitation results, and remediation recommendations. Which phase of the penetration testing methodology produces this?',
  '[{"key":"A","text":"Planning and scoping"},{"key":"B","text":"Discovery and enumeration"},{"key":"C","text":"Exploitation"},{"key":"D","text":"Reporting"}]'::jsonb,
  'D',
  'The reporting phase documents all findings from the penetration test, including scope, methodology, discovered vulnerabilities, successful exploits, and actionable remediation recommendations. Planning defines scope, discovery identifies targets and vulnerabilities, and exploitation attempts to leverage them.',
  'easy',
  ARRAY['penetration-testing','reporting','methodology','obj-4.9']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Before starting a penetration test, the testing team and the client sign a document specifying what systems can be tested, testing hours, and emergency contacts. What is this document?',
  '[{"key":"A","text":"Non-disclosure agreement"},{"key":"B","text":"Rules of engagement"},{"key":"C","text":"Service-level agreement"},{"key":"D","text":"Acceptable use policy"}]'::jsonb,
  'B',
  'Rules of engagement (ROE) define the scope, boundaries, timing, communication procedures, and authorization for a penetration test. An NDA protects confidential information, an SLA defines service expectations, and an AUP defines permitted use of IT resources.',
  'medium',
  ARRAY['penetration-testing','rules-of-engagement','assessment','obj-4.9']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security analyst needs to determine the exact content of network communications during a suspected data exfiltration. Firewall logs show connections but not payload data. What additional data source is needed?',
  '[{"key":"A","text":"NetFlow data"},{"key":"B","text":"Full packet capture"},{"key":"C","text":"SNMP traps"},{"key":"D","text":"Syslog messages"}]'::jsonb,
  'B',
  'Full packet capture (PCAP) records the complete content of network traffic including payload data, allowing reconstruction of the actual data that was transmitted. NetFlow shows traffic flow metadata but no payload, SNMP traps report device events, and syslog messages contain system log data.',
  'hard',
  ARRAY['investigation','packet-capture','data-exfiltration','obj-4.9']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization implements continuous monitoring that automatically scans systems for compliance with STIG guidelines and flags deviations. What does this practice prevent?',
  '[{"key":"A","text":"Zero-day exploits"},{"key":"B","text":"Configuration drift"},{"key":"C","text":"Social engineering"},{"key":"D","text":"Physical intrusion"}]'::jsonb,
  'B',
  'Continuous monitoring against STIG (Security Technical Implementation Guide) baselines detects configuration drift — when systems gradually deviate from their approved secure configurations due to unauthorized changes or updates. Zero-day exploits target unknown vulnerabilities, social engineering targets humans, and physical intrusion bypasses logical controls.',
  'hard',
  ARRAY['continuous-monitoring','stig','configuration-drift','compliance','obj-4.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security team integrates their SIEM with their ticketing system so that high-severity alerts automatically create incident tickets and assign them to on-call analysts. What does this represent?',
  '[{"key":"A","text":"Manual incident response"},{"key":"B","text":"Security orchestration"},{"key":"C","text":"Vulnerability scanning"},{"key":"D","text":"Threat hunting"}]'::jsonb,
  'B',
  'Security orchestration connects different security tools and automates workflows between them — in this case, linking SIEM alerts to automatic ticket creation and assignment. Manual incident response requires human action, vulnerability scanning identifies weaknesses, and threat hunting is proactive investigation by analysts.',
  'medium',
  ARRAY['orchestration','automation','siem-integration','ticketing','obj-4.7']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '4.0';
