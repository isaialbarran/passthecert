-- Domain 2.0: Threats, Vulnerabilities, and Mitigations — Batch 2 (40 questions)
-- Objectives: 2.1-2.5
-- Topics: supply chain, credential attacks, fileless malware, DNS attacks, privilege escalation, IoC, MITRE ATT&CK

-- Q1: Supply chain attack (software) — easy
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A widely used open-source library is compromised when an attacker injects malicious code into an update. Thousands of organizations install the update automatically. Which attack type does this describe?',
  '[{"key":"A","text":"Watering hole attack"},{"key":"B","text":"Software supply chain attack"},{"key":"C","text":"Trojan horse"},{"key":"D","text":"Backdoor installation"}]'::jsonb,
  'B',
  'A software supply chain attack compromises a trusted vendor or dependency so that downstream consumers unknowingly install malicious code. A is wrong because a watering hole targets a website visitors frequent, not a software dependency. C is wrong because a trojan disguises itself as legitimate software but is not injected into a real update chain. D is wrong because a backdoor is a persistence mechanism, not the attack vector described here.',
  'easy',
  ARRAY['supply-chain','software','obj-2.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q2: Supply chain attack (hardware) — medium
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'During a firmware audit, security engineers discover unauthorized chips soldered onto server motherboards received from an overseas manufacturer. Which threat does this BEST illustrate?',
  '[{"key":"A","text":"Rootkit installation"},{"key":"B","text":"Insider threat"},{"key":"C","text":"Hardware supply chain attack"},{"key":"D","text":"Evil twin deployment"}]'::jsonb,
  'C',
  'A hardware supply chain attack occurs when physical components are tampered with before delivery to the buyer. A is wrong because rootkits are software-based persistence tools, not physical implants. B is wrong because the threat originates from an external manufacturer, not an internal employee. D is wrong because an evil twin is a rogue wireless access point.',
  'medium',
  ARRAY['supply-chain','hardware','obj-2.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q3: Credential stuffing — easy
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An attacker obtains a database of username/password pairs leaked from a social media breach and uses them to log in to a banking application. Which attack is this?',
  '[{"key":"A","text":"Brute force"},{"key":"B","text":"Password spraying"},{"key":"C","text":"Credential stuffing"},{"key":"D","text":"Rainbow table attack"}]'::jsonb,
  'C',
  'Credential stuffing uses previously stolen username/password combinations against other services, exploiting password reuse. A is wrong because brute force tries every possible combination, not known credentials. B is wrong because password spraying tries one common password across many accounts. D is wrong because a rainbow table attack cracks password hashes, not live logins.',
  'easy',
  ARRAY['credential-stuffing','authentication-attack','obj-2.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q4: Password spraying — medium
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A SOC analyst notices thousands of failed login attempts across 500 different user accounts, but each account shows only one or two failures. Which attack technique is MOST likely occurring?',
  '[{"key":"A","text":"Credential stuffing"},{"key":"B","text":"Brute force attack"},{"key":"C","text":"Password spraying"},{"key":"D","text":"Dictionary attack"}]'::jsonb,
  'C',
  'Password spraying tries a small number of common passwords against many accounts to avoid lockout thresholds. A is wrong because credential stuffing uses known leaked credential pairs. B is wrong because brute force concentrates many attempts on a single account. D is wrong because a dictionary attack also targets individual accounts with many password guesses.',
  'medium',
  ARRAY['password-spraying','authentication-attack','obj-2.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q5: Brute force — easy
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An IDS alert shows 40,000 login attempts against a single admin account in the last hour, each with a different password. Which attack is MOST likely in progress?',
  '[{"key":"A","text":"Password spraying"},{"key":"B","text":"Credential stuffing"},{"key":"C","text":"Pass-the-hash"},{"key":"D","text":"Brute force attack"}]'::jsonb,
  'D',
  'A brute force attack systematically tries many passwords against a single account. A is wrong because password spraying distributes attempts across many accounts. B is wrong because credential stuffing uses known credential pairs from breaches. C is wrong because pass-the-hash uses captured NTLM hashes, not password guessing.',
  'easy',
  ARRAY['brute-force','authentication-attack','obj-2.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q6: Pass-the-hash — medium
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'After compromising a workstation, an attacker extracts NTLM hashes from memory and uses them to authenticate to other systems on the domain without knowing the plaintext passwords. Which attack is this?',
  '[{"key":"A","text":"Kerberoasting"},{"key":"B","text":"Pass-the-hash"},{"key":"C","text":"Credential stuffing"},{"key":"D","text":"Rainbow table attack"}]'::jsonb,
  'B',
  'Pass-the-hash uses captured password hashes directly for authentication without needing to crack them. A is wrong because Kerberoasting targets Kerberos service tickets, not NTLM hashes. C is wrong because credential stuffing uses plaintext credentials from breaches. D is wrong because rainbow table attacks attempt to reverse hashes into plaintext.',
  'medium',
  ARRAY['pass-the-hash','lateral-movement','obj-2.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q7: Fileless malware — medium
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An endpoint detection tool flags a PowerShell process that is downloading and executing code entirely in memory with no files written to disk. Which type of malware does this BEST describe?',
  '[{"key":"A","text":"Rootkit"},{"key":"B","text":"Fileless malware"},{"key":"C","text":"Polymorphic virus"},{"key":"D","text":"Boot sector virus"}]'::jsonb,
  'B',
  'Fileless malware operates entirely in memory using legitimate tools like PowerShell, leaving no traditional file artifacts on disk. A is wrong because rootkits are designed to hide their presence but typically involve files on disk. C is wrong because polymorphic viruses change their code signature but still exist as files. D is wrong because boot sector viruses infect the master boot record on disk.',
  'medium',
  ARRAY['fileless-malware','malware','obj-2.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q8: Fileless malware detection — hard
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security team cannot find any malicious executables on a compromised server, yet the system is beaconing to a C2 server via scheduled WMI subscriptions. Which mitigation would BEST address this threat?',
  '[{"key":"A","text":"Update antivirus signature definitions"},{"key":"B","text":"Deploy a host-based firewall"},{"key":"C","text":"Enable PowerShell script block logging and EDR behavioral analysis"},{"key":"D","text":"Run a full-disk antimalware scan"}]'::jsonb,
  'C',
  'Fileless malware evades signature-based detection because it leaves no files on disk. Script block logging and EDR behavioral analysis detect malicious in-memory activity. A is wrong because signature-based AV cannot detect fileless threats with no file to scan. B is wrong because a firewall may block C2 traffic but does not address the root cause. D is wrong because a disk scan will find nothing since the malware is memory-resident only.',
  'hard',
  ARRAY['fileless-malware','detection','edr','obj-2.2','obj-2.5']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q9: Keylogger — easy
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An employee reports that their online banking credentials were stolen despite using a strong, unique password and no phishing emails were received. IT discovers unauthorized software recording every keystroke. What was installed?',
  '[{"key":"A","text":"Adware"},{"key":"B","text":"Spyware"},{"key":"C","text":"Keylogger"},{"key":"D","text":"Ransomware"}]'::jsonb,
  'C',
  'A keylogger captures every keystroke, enabling an attacker to harvest passwords, credit card numbers, and other sensitive input. A is wrong because adware displays unwanted ads but does not record keystrokes. B is wrong because spyware is a broader category; the scenario specifically describes keystroke capture. D is wrong because ransomware encrypts files for ransom, it does not silently record input.',
  'easy',
  ARRAY['keylogger','malware','obj-2.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q10: Spyware in enterprise — medium
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'After installing a free PDF tool, multiple employees notice their browsers redirecting to unfamiliar search engines and internal network diagrams appearing in outbound traffic logs. Which type of malware is MOST likely responsible?',
  '[{"key":"A","text":"Ransomware"},{"key":"B","text":"Spyware"},{"key":"C","text":"Logic bomb"},{"key":"D","text":"Worm"}]'::jsonb,
  'B',
  'Spyware covertly collects data such as browsing habits and sensitive files and transmits it externally. Browser redirects and exfiltrated data are hallmark spyware behaviors. A is wrong because ransomware encrypts data and demands payment. C is wrong because a logic bomb triggers a destructive payload upon a condition, not continuous data collection. D is wrong because a worm self-replicates across networks but does not focus on data exfiltration.',
  'medium',
  ARRAY['spyware','malware','enterprise','obj-2.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q11: Logic bomb — medium
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A disgruntled developer embeds code that will delete the company''s production database if their employee record is removed from the HR system. Which type of threat does this represent?',
  '[{"key":"A","text":"Trojan"},{"key":"B","text":"Time bomb"},{"key":"C","text":"Logic bomb"},{"key":"D","text":"Backdoor"}]'::jsonb,
  'C',
  'A logic bomb is malicious code that executes when a specific condition is met — in this case, the removal of the developer''s HR record. A is wrong because a trojan disguises itself as legitimate software to gain initial access. B is wrong because a time bomb triggers at a specific date/time, not a logical condition. D is wrong because a backdoor provides unauthorized access but does not trigger a destructive payload based on a condition.',
  'medium',
  ARRAY['logic-bomb','insider-threat','malware','obj-2.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q12: DNS poisoning — medium
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Users on a corporate network are redirected to a fake banking site even though they typed the correct URL. Investigation reveals the internal DNS server is returning an incorrect IP address for the banking domain. Which attack has occurred?',
  '[{"key":"A","text":"ARP poisoning"},{"key":"B","text":"DNS poisoning"},{"key":"C","text":"URL redirection"},{"key":"D","text":"BGP hijacking"}]'::jsonb,
  'B',
  'DNS poisoning corrupts DNS cache entries so that legitimate domain names resolve to attacker-controlled IP addresses. A is wrong because ARP poisoning targets Layer 2 MAC-to-IP mappings, not DNS. C is wrong because URL redirection is an application-level issue, not a DNS-level attack. D is wrong because BGP hijacking manipulates internet routing tables, not DNS resolution.',
  'medium',
  ARRAY['dns-poisoning','dns-attack','obj-2.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q13: DNS tunneling — hard
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A firewall blocks all outbound traffic except DNS on port 53. A threat analyst notices unusually large TXT record queries to a single external domain. Which technique is the attacker MOST likely using to exfiltrate data?',
  '[{"key":"A","text":"Domain hijacking"},{"key":"B","text":"DNS tunneling"},{"key":"C","text":"DNS poisoning"},{"key":"D","text":"Fast-flux DNS"}]'::jsonb,
  'B',
  'DNS tunneling encodes data inside DNS queries and responses, using allowed DNS traffic as a covert channel to bypass firewalls. A is wrong because domain hijacking takes over a legitimate domain registration. C is wrong because DNS poisoning corrupts cache entries to redirect traffic. D is wrong because fast-flux DNS rapidly rotates IP addresses to hide malicious servers, not to exfiltrate data.',
  'hard',
  ARRAY['dns-tunneling','dns-attack','data-exfiltration','obj-2.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q14: Domain hijacking — easy
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An attacker gains access to a company''s domain registrar account and transfers the company''s primary domain to a server they control. Which attack is this?',
  '[{"key":"A","text":"DNS tunneling"},{"key":"B","text":"Pharming"},{"key":"C","text":"Domain hijacking"},{"key":"D","text":"Typosquatting"}]'::jsonb,
  'C',
  'Domain hijacking occurs when an attacker takes control of a domain''s registration, allowing them to redirect all traffic. A is wrong because DNS tunneling uses DNS queries to exfiltrate data. B is wrong because pharming redirects users via DNS manipulation, not registrar takeover. D is wrong because typosquatting registers look-alike domains, not stealing existing ones.',
  'easy',
  ARRAY['domain-hijacking','dns-attack','obj-2.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q15: ARP poisoning — medium
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A penetration tester on a local network sends gratuitous ARP replies to associate their MAC address with the default gateway''s IP. All LAN traffic now flows through the tester''s machine. Which attack is being performed?',
  '[{"key":"A","text":"MAC flooding"},{"key":"B","text":"DNS poisoning"},{"key":"C","text":"VLAN hopping"},{"key":"D","text":"ARP poisoning"}]'::jsonb,
  'D',
  'ARP poisoning (spoofing) sends fake ARP replies to map the attacker''s MAC address to a legitimate IP, enabling traffic interception. A is wrong because MAC flooding overwhelms a switch''s CAM table to force broadcast mode. B is wrong because DNS poisoning targets name resolution, not Layer 2 addressing. C is wrong because VLAN hopping bypasses VLAN boundaries, not ARP tables.',
  'medium',
  ARRAY['arp-poisoning','network-attack','obj-2.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q16: Replay attack — medium
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An attacker captures a valid authentication token transmitted over the network and retransmits it later to gain unauthorized access. Which type of attack is this?',
  '[{"key":"A","text":"On-path attack"},{"key":"B","text":"Session hijacking"},{"key":"C","text":"Replay attack"},{"key":"D","text":"Credential stuffing"}]'::jsonb,
  'C',
  'A replay attack captures and retransmits valid data (such as authentication tokens) to impersonate a legitimate user. A is wrong because an on-path (man-in-the-middle) attack actively intercepts and may alter traffic in real time. B is wrong because session hijacking takes over an active session, not a previously captured token. D is wrong because credential stuffing uses stolen plaintext credentials from breaches.',
  'medium',
  ARRAY['replay-attack','network-attack','obj-2.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q17: Bluejacking — easy
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A user at an airport receives unsolicited messages on their phone via Bluetooth from an unknown device. No data was stolen. Which Bluetooth attack is this?',
  '[{"key":"A","text":"Bluesnarfing"},{"key":"B","text":"Bluejacking"},{"key":"C","text":"Evil twin"},{"key":"D","text":"NFC relay"}]'::jsonb,
  'B',
  'Bluejacking sends unsolicited messages to Bluetooth-enabled devices. It is annoying but does not steal data. A is wrong because bluesnarfing involves unauthorized access to data on the device. C is wrong because an evil twin is a rogue Wi-Fi access point. D is wrong because an NFC relay attack intercepts near-field communication, not Bluetooth messages.',
  'easy',
  ARRAY['bluejacking','bluetooth','wireless-attack','obj-2.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q18: Bluesnarfing — easy
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An attacker in a coffee shop exploits a vulnerability in a nearby phone''s Bluetooth stack to download the contact list and calendar without the owner''s knowledge. Which attack is this?',
  '[{"key":"A","text":"Bluejacking"},{"key":"B","text":"Bluesnarfing"},{"key":"C","text":"Skimming"},{"key":"D","text":"Shoulder surfing"}]'::jsonb,
  'B',
  'Bluesnarfing is the unauthorized access and theft of data from a Bluetooth-enabled device. A is wrong because bluejacking only sends unsolicited messages and does not access data. C is wrong because skimming captures payment card data from card readers. D is wrong because shoulder surfing involves visually observing someone''s screen or keyboard.',
  'easy',
  ARRAY['bluesnarfing','bluetooth','wireless-attack','obj-2.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q19: RFID/NFC attack — medium
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An attacker stands near an office entrance with a concealed reader and captures data from employees'' contactless access badges as they walk by. Which attack vector is being exploited?',
  '[{"key":"A","text":"Bluetooth sniffing"},{"key":"B","text":"RFID skimming"},{"key":"C","text":"Wi-Fi deauthentication"},{"key":"D","text":"Tailgating"}]'::jsonb,
  'B',
  'RFID skimming uses a concealed reader to capture data from RFID-enabled badges or cards at short range without the victim''s knowledge. A is wrong because Bluetooth sniffing targets Bluetooth protocols, not contactless badges. C is wrong because Wi-Fi deauthentication disrupts wireless connections. D is wrong because tailgating is physically following someone through a secured door.',
  'medium',
  ARRAY['rfid','nfc','physical-attack','obj-2.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q20: Cryptographic downgrade attack — hard
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'During a TLS handshake, an on-path attacker modifies the client''s hello message to advertise support for only SSL 3.0, forcing the server to use a weak cipher suite. Which cryptographic attack is this?',
  '[{"key":"A","text":"Birthday attack"},{"key":"B","text":"Collision attack"},{"key":"C","text":"Downgrade attack"},{"key":"D","text":"Known plaintext attack"}]'::jsonb,
  'C',
  'A downgrade attack forces a connection to use a weaker, vulnerable protocol version or cipher suite. A is wrong because a birthday attack exploits the probability of hash collisions in a large set. B is wrong because a collision attack finds two inputs producing the same hash, but does not manipulate protocol negotiation. D is wrong because a known plaintext attack uses knowledge of both plaintext and ciphertext pairs to derive the key.',
  'hard',
  ARRAY['downgrade-attack','cryptographic-attack','tls','obj-2.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q21: Birthday/collision attack — hard
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A researcher demonstrates that two different PDF documents can produce the same SHA-1 hash value, allowing a malicious document to be substituted for a legitimate one. Which cryptographic attack does this demonstrate?',
  '[{"key":"A","text":"Downgrade attack"},{"key":"B","text":"Brute force attack"},{"key":"C","text":"Collision attack"},{"key":"D","text":"Key stretching attack"}]'::jsonb,
  'C',
  'A collision attack finds two different inputs that produce the same hash output, undermining integrity verification. A is wrong because a downgrade attack forces weaker protocol versions. B is wrong because brute force exhaustively tries all possible inputs, not specifically two that match. D is wrong because key stretching strengthens passwords by adding computational work, it is a defense mechanism.',
  'hard',
  ARRAY['collision-attack','birthday-attack','cryptographic-attack','obj-2.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q22: Directory traversal — medium
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A web application vulnerability scanner reports that the URL parameter "file=../../../../etc/passwd" successfully returns the server''s password file. Which vulnerability has been identified?',
  '[{"key":"A","text":"SQL injection"},{"key":"B","text":"Directory traversal"},{"key":"C","text":"LDAP injection"},{"key":"D","text":"Command injection"}]'::jsonb,
  'B',
  'Directory traversal (path traversal) uses sequences like ../ to navigate outside the web root and access restricted files on the server. A is wrong because SQL injection manipulates database queries. C is wrong because LDAP injection targets directory service queries. D is wrong because command injection executes OS commands, not filesystem navigation.',
  'medium',
  ARRAY['directory-traversal','web-attack','obj-2.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q23: LDAP injection — medium
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An attacker enters the string "admin)(|(password=*))" into a web application''s username field. The application passes this input directly to an Active Directory query, returning all user records. Which attack was performed?',
  '[{"key":"A","text":"SQL injection"},{"key":"B","text":"XML injection"},{"key":"C","text":"LDAP injection"},{"key":"D","text":"XSS"}]'::jsonb,
  'C',
  'LDAP injection manipulates LDAP queries by inserting special characters into unsanitized input fields that query directory services. A is wrong because SQL injection targets relational database queries, not directory services. B is wrong because XML injection targets XML parsers. D is wrong because XSS injects scripts into web pages rendered by other users'' browsers.',
  'medium',
  ARRAY['ldap-injection','injection-attack','obj-2.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q24: API attack — medium
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A mobile application''s REST API endpoint /api/users/1045 returns the profile of user 1045. An attacker changes the ID to /api/users/1046 and retrieves another user''s private data. Which vulnerability does this exploit?',
  '[{"key":"A","text":"Broken access control (IDOR)"},{"key":"B","text":"SQL injection"},{"key":"C","text":"Directory traversal"},{"key":"D","text":"CSRF"}]'::jsonb,
  'A',
  'Insecure Direct Object Reference (IDOR) is a broken access control flaw where the API fails to verify the requesting user is authorized to access the referenced object. B is wrong because SQL injection manipulates database queries through input fields. C is wrong because directory traversal navigates the file system. D is wrong because CSRF tricks a user into making unintended requests using their authenticated session.',
  'medium',
  ARRAY['api-attack','idor','broken-access-control','obj-2.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q25: Integer overflow — hard
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A shopping cart application stores item quantities as a 16-bit unsigned integer. An attacker sets the quantity to 65,536, which wraps around to 0, resulting in a free order. Which vulnerability was exploited?',
  '[{"key":"A","text":"Buffer overflow"},{"key":"B","text":"Integer overflow"},{"key":"C","text":"Race condition"},{"key":"D","text":"Input validation bypass"}]'::jsonb,
  'B',
  'An integer overflow occurs when a value exceeds the maximum size of its data type and wraps around, producing unexpected results. A is wrong because a buffer overflow writes data beyond allocated memory bounds, not numeric wrapping. C is wrong because a race condition exploits timing between operations. D is wrong because while input validation could prevent this, the specific vulnerability exploited is integer overflow.',
  'hard',
  ARRAY['integer-overflow','application-attack','obj-2.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q26: Privilege escalation — vertical — medium
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A standard user on a Linux server exploits a kernel vulnerability to gain root access. Which type of privilege escalation has occurred?',
  '[{"key":"A","text":"Horizontal privilege escalation"},{"key":"B","text":"Vertical privilege escalation"},{"key":"C","text":"Lateral movement"},{"key":"D","text":"Credential harvesting"}]'::jsonb,
  'B',
  'Vertical privilege escalation occurs when a user gains higher-level permissions than their role allows, such as standard user to root. A is wrong because horizontal escalation means accessing another user''s resources at the same privilege level. C is wrong because lateral movement involves moving between systems, not escalating permissions. D is wrong because credential harvesting collects credentials but does not inherently elevate privileges.',
  'medium',
  ARRAY['privilege-escalation','vertical','obj-2.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q27: Privilege escalation — horizontal — medium
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A user logged into an HR portal modifies a URL parameter to view another employee''s pay stub without gaining additional system permissions. Which type of privilege escalation is this?',
  '[{"key":"A","text":"Vertical privilege escalation"},{"key":"B","text":"Horizontal privilege escalation"},{"key":"C","text":"Rootkit installation"},{"key":"D","text":"Session fixation"}]'::jsonb,
  'B',
  'Horizontal privilege escalation occurs when a user accesses resources belonging to another user at the same privilege level. A is wrong because vertical escalation involves gaining higher permissions such as admin or root. C is wrong because a rootkit hides malicious activity, it does not describe accessing peer-level data. D is wrong because session fixation forces a user to use a known session ID.',
  'medium',
  ARRAY['privilege-escalation','horizontal','obj-2.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q28: DLL injection — hard
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Malware on a Windows workstation forces a trusted process to load an attacker-controlled DLL into its memory space, allowing code execution under the trusted process''s context. Which technique is this?',
  '[{"key":"A","text":"Process hollowing"},{"key":"B","text":"DLL injection"},{"key":"C","text":"Fileless malware"},{"key":"D","text":"Rootkit"}]'::jsonb,
  'B',
  'DLL injection forces a running process to load a malicious dynamic-link library, executing code within the context of a trusted process. A is wrong because process hollowing replaces the entire memory of a legitimate process with malicious code, not injecting a library. C is wrong because fileless malware describes a broader category of memory-only attacks. D is wrong because a rootkit hides its presence but does not specifically describe injecting code into another process''s address space.',
  'hard',
  ARRAY['dll-injection','memory-injection','obj-2.3']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q29: Malicious USB / baiting — easy
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'USB drives labeled "Employee Bonuses Q4" are left in a company parking lot. When an employee plugs one in, malware installs automatically. Which social engineering technique was used?',
  '[{"key":"A","text":"Tailgating"},{"key":"B","text":"Baiting"},{"key":"C","text":"Pretexting"},{"key":"D","text":"Impersonation"}]'::jsonb,
  'B',
  'Baiting lures victims with an enticing item — in this case a USB drive with a tempting label — to trick them into compromising their system. A is wrong because tailgating involves physically following someone through a secured entrance. C is wrong because pretexting creates a fabricated scenario during a conversation to extract information. D is wrong because impersonation involves posing as another person, not leaving physical objects.',
  'easy',
  ARRAY['baiting','usb-attack','social-engineering','obj-2.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q30: Business email compromise — medium
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'The CFO receives an email that appears to come from the CEO requesting an urgent wire transfer to a new vendor account. The email address is spoofed using a lookalike domain. Which attack does this describe?',
  '[{"key":"A","text":"Spear phishing"},{"key":"B","text":"Business email compromise"},{"key":"C","text":"Whaling"},{"key":"D","text":"Vishing"}]'::jsonb,
  'B',
  'Business email compromise (BEC) impersonates executives or trusted parties via email to trick employees into transferring funds or sharing sensitive data. A is wrong because spear phishing is a targeted phishing email but does not specifically impersonate internal executives for financial fraud. C is wrong because whaling targets executives as victims, whereas here the executive is being impersonated. D is wrong because vishing uses voice calls, not email.',
  'medium',
  ARRAY['bec','ceo-fraud','social-engineering','obj-2.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q31: Insider threat — intentional — medium
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A database administrator who has been passed over for promotion copies the entire customer database to a personal cloud storage account before resigning. Which threat category does this BEST represent?',
  '[{"key":"A","text":"Advanced persistent threat"},{"key":"B","text":"Unintentional insider threat"},{"key":"C","text":"Intentional insider threat"},{"key":"D","text":"Shadow IT"}]'::jsonb,
  'C',
  'An intentional insider threat occurs when a trusted employee deliberately misuses their access for malicious purposes. A is wrong because APTs are typically nation-state or organized groups conducting long-term espionage. B is wrong because the action was deliberate, not accidental. D is wrong because shadow IT refers to unauthorized technology use, not deliberate data theft.',
  'medium',
  ARRAY['insider-threat','intentional','data-exfiltration','obj-2.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q32: Insider threat — unintentional — easy
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An employee accidentally emails a spreadsheet containing customer Social Security numbers to an external distribution list. Which type of threat does this scenario represent?',
  '[{"key":"A","text":"Intentional insider threat"},{"key":"B","text":"Unintentional insider threat"},{"key":"C","text":"Social engineering"},{"key":"D","text":"Data poisoning"}]'::jsonb,
  'B',
  'An unintentional insider threat occurs when an employee inadvertently causes a security incident without malicious intent. A is wrong because the action was accidental, not deliberate. C is wrong because no external manipulation was involved. D is wrong because data poisoning corrupts training data for machine learning models.',
  'easy',
  ARRAY['insider-threat','unintentional','data-loss','obj-2.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q33: Indicators of compromise — beaconing — medium
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A SIEM rule triggers when a workstation sends HTTPS requests to the same external IP every 60 seconds, 24 hours a day. Which indicator of compromise does this pattern BEST suggest?',
  '[{"key":"A","text":"Port scanning"},{"key":"B","text":"Beaconing"},{"key":"C","text":"ARP flooding"},{"key":"D","text":"DNS zone transfer"}]'::jsonb,
  'B',
  'Beaconing is a pattern of regular, periodic outbound communication from a compromised host to a command-and-control server. A is wrong because port scanning probes for open ports, not regular outbound connections. C is wrong because ARP flooding targets the local network switch. D is wrong because a DNS zone transfer copies DNS records and is not related to periodic outbound traffic patterns.',
  'medium',
  ARRAY['beaconing','ioc','c2','obj-2.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q34: IoC — unusual outbound traffic — medium
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A network monitoring tool alerts that a file server which normally generates 2 GB of outbound traffic daily has sent 50 GB to an external IP in the last 6 hours. Which indicator of compromise should the analyst investigate FIRST?',
  '[{"key":"A","text":"Resource consumption anomaly"},{"key":"B","text":"Data exfiltration"},{"key":"C","text":"Denial of service"},{"key":"D","text":"Unauthorized software installation"}]'::jsonb,
  'B',
  'A sudden, massive increase in outbound data to an external destination is a strong indicator of data exfiltration. A is wrong because while resource consumption may be elevated, the primary concern is the destination and volume of outbound data. C is wrong because denial of service involves inbound traffic overload, not outbound data transfer. D is wrong because unauthorized software would not directly explain the spike in outbound network traffic.',
  'medium',
  ARRAY['data-exfiltration','ioc','network-anomaly','obj-2.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q35: Threat intelligence — OSINT — easy
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security analyst reviews publicly available government advisories, social media feeds, and vulnerability databases to identify emerging threats. Which type of threat intelligence source is the analyst using?',
  '[{"key":"A","text":"Proprietary intelligence"},{"key":"B","text":"OSINT"},{"key":"C","text":"Dark web intelligence"},{"key":"D","text":"ISAC reporting"}]'::jsonb,
  'B',
  'OSINT (open-source intelligence) is gathered from publicly available sources such as government advisories, social media, and vulnerability databases. A is wrong because proprietary intelligence comes from paid commercial feeds. C is wrong because dark web intelligence requires accessing hidden services and underground forums. D is wrong because ISAC (Information Sharing and Analysis Center) reporting comes from industry-specific member organizations, not general public sources.',
  'easy',
  ARRAY['osint','threat-intelligence','obj-2.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q36: Threat intelligence — ISAC — easy
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A hospital''s security team receives a sector-specific alert about ransomware campaigns targeting healthcare organizations from a member-driven sharing organization. Which source provided this intelligence?',
  '[{"key":"A","text":"OSINT feed"},{"key":"B","text":"Dark web monitoring"},{"key":"C","text":"Health-ISAC"},{"key":"D","text":"Vendor threat report"}]'::jsonb,
  'C',
  'ISACs (Information Sharing and Analysis Centers) are sector-specific organizations where members share threat intelligence relevant to their industry. A is wrong because OSINT is publicly available and not sector-specific or member-driven. B is wrong because dark web monitoring involves scanning underground forums. D is wrong because vendor threat reports come from security product companies, not industry-specific sharing organizations.',
  'easy',
  ARRAY['isac','threat-intelligence','obj-2.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q37: MITRE ATT&CK — medium
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A threat hunting team maps observed attacker behaviors to a framework that categorizes adversary tactics and techniques based on real-world observations. Which framework are they MOST likely using?',
  '[{"key":"A","text":"NIST CSF"},{"key":"B","text":"MITRE ATT&CK"},{"key":"C","text":"ISO 27001"},{"key":"D","text":"CIS Controls"}]'::jsonb,
  'B',
  'MITRE ATT&CK is a knowledge base of adversary tactics, techniques, and procedures (TTPs) based on real-world observations. A is wrong because NIST CSF is a cybersecurity risk management framework, not a threat behavior catalog. C is wrong because ISO 27001 is an information security management standard. D is wrong because CIS Controls are prioritized security best practices, not a catalog of adversary behaviors.',
  'medium',
  ARRAY['mitre-attack','threat-intelligence','ttp','obj-2.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q38: Patch management as mitigation — easy
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A vulnerability scan reveals that 30 servers are running an outdated version of Apache with a known remote code execution flaw. Which mitigation should be applied FIRST?',
  '[{"key":"A","text":"Deploy a WAF in front of the servers"},{"key":"B","text":"Segment the servers into a separate VLAN"},{"key":"C","text":"Apply the vendor-released security patch"},{"key":"D","text":"Implement an IDS to monitor the servers"}]'::jsonb,
  'C',
  'Patching directly addresses the root cause by eliminating the known vulnerability. A is wrong because a WAF provides a layer of defense but does not fix the underlying vulnerability. B is wrong because segmentation limits blast radius but the servers remain exploitable. D is wrong because an IDS detects attacks but does not prevent exploitation of the vulnerability.',
  'easy',
  ARRAY['patch-management','mitigation','obj-2.5']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q39: Access control lists — medium
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A firewall administrator needs to ensure that only the finance department can access the accounting server on TCP port 443. Which control should the administrator configure?',
  '[{"key":"A","text":"Network access control list"},{"key":"B","text":"Full-disk encryption"},{"key":"C","text":"Intrusion prevention system rule"},{"key":"D","text":"SIEM correlation rule"}]'::jsonb,
  'A',
  'A network ACL explicitly permits or denies traffic based on source, destination, port, and protocol, restricting access to authorized groups. B is wrong because full-disk encryption protects data at rest, not network access. C is wrong because an IPS rule detects and blocks malicious traffic patterns, not legitimate access control. D is wrong because a SIEM rule generates alerts and correlations, it does not enforce access restrictions.',
  'medium',
  ARRAY['acl','access-control','mitigation','obj-2.5']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

-- Q40: Encryption as mitigation — medium
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A company stores sensitive customer data in a cloud database. A risk assessment identifies that a breach could expose data at rest. Which mitigation BEST protects the data if the storage layer is compromised?',
  '[{"key":"A","text":"Network segmentation"},{"key":"B","text":"Encryption at rest using AES-256"},{"key":"C","text":"Multi-factor authentication"},{"key":"D","text":"Regular vulnerability scanning"}]'::jsonb,
  'B',
  'Encryption at rest renders data unreadable without the decryption key, protecting it even if the storage layer is breached. A is wrong because network segmentation limits access paths but does not protect data once an attacker reaches the database. C is wrong because MFA strengthens authentication but does not protect stored data after access is obtained. D is wrong because vulnerability scanning identifies weaknesses but does not directly protect data at rest.',
  'medium',
  ARRAY['encryption','data-at-rest','mitigation','obj-2.5']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '2.0';

