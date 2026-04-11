-- Domain 1.0: General Security Concepts — Batch 2 (21 questions)
-- Objectives: 1.1-1.4
-- Topics: PKI, key management, steganography, physical security, AAA, separation of duties

-- ─── 1.4 Explain the purpose and use of cryptographic concepts ─────────────────

-- Q1: Certificate revocation (easy)
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security administrator discovers that a web server''s private key has been compromised. Which action should the administrator take FIRST regarding the server''s digital certificate?',
  '[{"key":"A","text":"Renew the certificate with the same key pair"},{"key":"B","text":"Revoke the certificate through the issuing CA"},{"key":"C","text":"Update the CRL distribution point URL"},{"key":"D","text":"Enable OCSP stapling on the web server"}]'::jsonb,
  'B',
  'When a private key is compromised, the certificate must be revoked immediately through the issuing Certificate Authority (CA) to prevent an attacker from impersonating the server. A is wrong because renewing with the same compromised key pair does not resolve the issue. C is wrong because updating the CRL distribution point URL is an administrative task unrelated to revoking the specific certificate. D is wrong because OCSP stapling improves revocation-check performance but does not itself revoke the certificate.',
  'easy',
  ARRAY['pki','certificate-revocation','ca','obj-1.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';

-- Q2: OCSP vs CRL (medium)
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A company wants to reduce the latency of certificate revocation checks for its customer-facing portal. Which approach provides real-time revocation status with the lowest bandwidth overhead?',
  '[{"key":"A","text":"Publish a CRL hourly and cache it at the edge"},{"key":"B","text":"Use OCSP to query the CA for individual certificate status"},{"key":"C","text":"Implement certificate pinning in the mobile app"},{"key":"D","text":"Shorten the certificate validity period to 30 days"}]'::jsonb,
  'B',
  'OCSP (Online Certificate Status Protocol) provides real-time, per-certificate revocation status with minimal bandwidth because only the requested certificate''s status is returned. A is wrong because CRLs are downloaded in bulk and hourly publishing still introduces latency gaps. C is wrong because certificate pinning prevents substitution attacks but does not check revocation status. D is wrong because shortening validity reduces exposure but does not provide real-time revocation information.',
  'medium',
  ARRAY['pki','ocsp','crl','certificate-revocation','obj-1.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';

-- Q3: Certificate pinning (medium)
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A mobile banking application refuses to connect after the bank rotates its TLS certificate, even though the new certificate is valid and trusted by the OS. What is the MOST likely cause?',
  '[{"key":"A","text":"The new certificate uses a deprecated cipher suite"},{"key":"B","text":"The application implements certificate pinning against the old certificate"},{"key":"C","text":"OCSP stapling is misconfigured on the server"},{"key":"D","text":"The certificate''s Subject Alternative Name does not match the domain"}]'::jsonb,
  'B',
  'Certificate pinning binds the application to a specific certificate or public key. When the certificate is rotated without updating the pin, the application rejects the new certificate even if it is otherwise valid. A is wrong because a deprecated cipher suite would cause a negotiation failure, not a pinning rejection. C is wrong because OCSP stapling issues would produce a revocation-check error, not a trust failure on a valid cert. D is wrong because a SAN mismatch would affect all clients, not just the app.',
  'medium',
  ARRAY['pki','certificate-pinning','tls','obj-1.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';

-- Q4: Key escrow (easy)
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization stores copies of employees'' encryption private keys with a trusted third party so that encrypted data can be recovered if an employee leaves or loses access. This practice is BEST described as:',
  '[{"key":"A","text":"Key stretching"},{"key":"B","text":"Key escrow"},{"key":"C","text":"Key exchange"},{"key":"D","text":"Key rotation"}]'::jsonb,
  'B',
  'Key escrow is the practice of storing copies of cryptographic keys with a trusted third party to enable data recovery. A is wrong because key stretching strengthens weak keys or passwords by running them through additional iterations. C is wrong because key exchange is the process of securely sharing keys between parties (e.g., Diffie-Hellman). D is wrong because key rotation is the periodic replacement of keys to limit exposure.',
  'easy',
  ARRAY['key-management','key-escrow','obj-1.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';

-- Q5: Digital signatures (medium)
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'When a sender digitally signs an email, which sequence correctly describes the signing process?',
  '[{"key":"A","text":"The message is encrypted with the sender''s public key, then hashed"},{"key":"B","text":"A hash of the message is encrypted with the sender''s private key"},{"key":"C","text":"The message is encrypted with the recipient''s private key, then hashed"},{"key":"D","text":"A hash of the message is encrypted with the recipient''s public key"}]'::jsonb,
  'B',
  'A digital signature is created by first hashing the message, then encrypting that hash with the sender''s private key. The recipient verifies by decrypting with the sender''s public key and comparing hashes. A is wrong because encrypting the full message with the sender''s public key provides confidentiality (and only the sender could decrypt it, which is backwards). C is wrong because the recipient''s private key should never be available to the sender. D is wrong because encrypting with the recipient''s public key provides confidentiality, not a signature.',
  'medium',
  ARRAY['digital-signatures','cryptography','obj-1.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';

-- Q6: Steganography (easy)
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An analyst discovers that a disgruntled employee has been embedding proprietary source code within image files posted to a public forum. Which technique is the employee using?',
  '[{"key":"A","text":"Obfuscation"},{"key":"B","text":"Steganography"},{"key":"C","text":"Tokenization"},{"key":"D","text":"Data masking"}]'::jsonb,
  'B',
  'Steganography hides data within another medium (such as an image file) so the existence of the hidden data is concealed. A is wrong because obfuscation makes code or data difficult to understand but does not hide it within another file. C is wrong because tokenization replaces sensitive data with non-sensitive placeholders. D is wrong because data masking obscures portions of data (e.g., showing only the last four digits of a credit card).',
  'easy',
  ARRAY['steganography','data-exfiltration','obj-1.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';

-- Q7: Salting passwords (medium)
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Two users choose the identical password, yet their stored hashes are completely different. Which technique BEST explains this?',
  '[{"key":"A","text":"Key stretching with bcrypt"},{"key":"B","text":"Adding a unique salt before hashing each password"},{"key":"C","text":"Using asymmetric encryption instead of hashing"},{"key":"D","text":"Applying obfuscation to the password field"}]'::jsonb,
  'B',
  'A salt is a unique random value prepended or appended to a password before hashing. Even identical passwords produce different hashes because each salt is different. A is wrong because key stretching adds computational cost but does not by itself guarantee different hashes for the same input (though bcrypt does include a salt — the question specifically asks what explains the differing hashes). C is wrong because asymmetric encryption is not used for password storage. D is wrong because obfuscation makes data harder to read but is not a hashing mechanism.',
  'medium',
  ARRAY['salting','password-security','hashing','obj-1.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';

-- Q8: Key stretching (medium)
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security engineer wants to make brute-force attacks against stored passwords computationally expensive. Which technique applies multiple iterations of a hashing function to increase the time required to test each guess?',
  '[{"key":"A","text":"Salting"},{"key":"B","text":"Steganography"},{"key":"C","text":"Key stretching with PBKDF2"},{"key":"D","text":"Tokenization"}]'::jsonb,
  'C',
  'Key stretching algorithms like PBKDF2 and bcrypt apply many iterations of a hash function, dramatically increasing the computation needed for each password guess and slowing brute-force attacks. A is wrong because salting ensures unique hashes but does not add computational cost. B is wrong because steganography hides data within other media and is unrelated to password storage. D is wrong because tokenization replaces data with tokens and is not a password-hardening mechanism.',
  'medium',
  ARRAY['key-stretching','pbkdf2','bcrypt','password-security','obj-1.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';

-- Q9: ECC vs RSA (hard)
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A development team is selecting an asymmetric algorithm for IoT devices with limited processing power and memory. Which algorithm provides equivalent security strength with significantly smaller key sizes compared to RSA?',
  '[{"key":"A","text":"AES-256"},{"key":"B","text":"SHA-3"},{"key":"C","text":"Elliptic Curve Cryptography (ECC)"},{"key":"D","text":"Blowfish"}]'::jsonb,
  'C',
  'ECC achieves equivalent security to RSA with much smaller key sizes (e.g., a 256-bit ECC key approximates a 3072-bit RSA key), making it ideal for resource-constrained devices. A is wrong because AES is a symmetric algorithm, not asymmetric. B is wrong because SHA-3 is a hashing algorithm, not an encryption algorithm. D is wrong because Blowfish is a symmetric block cipher.',
  'hard',
  ARRAY['ecc','rsa','asymmetric-encryption','iot','obj-1.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';

-- Q10: Perfect forward secrecy (hard)
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security architect wants to ensure that if the server''s long-term private key is compromised in the future, previously captured TLS sessions cannot be decrypted. Which property must the cipher suite support?',
  '[{"key":"A","text":"Authenticated encryption"},{"key":"B","text":"Perfect forward secrecy"},{"key":"C","text":"Certificate transparency"},{"key":"D","text":"Mutual authentication"}]'::jsonb,
  'B',
  'Perfect forward secrecy (PFS) uses ephemeral key pairs for each session, so compromising the long-term private key does not expose past session keys. A is wrong because authenticated encryption (e.g., AES-GCM) provides confidentiality and integrity simultaneously but does not protect past sessions from future key compromise. C is wrong because certificate transparency is a public logging framework for certificates, not a cipher suite property. D is wrong because mutual authentication verifies both parties'' identities but does not protect historical session data.',
  'hard',
  ARRAY['perfect-forward-secrecy','tls','cipher-suites','obj-1.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';

-- Q11: Cipher suites (medium)
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'During a TLS handshake, the client and server negotiate a cipher suite. Which components does a cipher suite typically define?',
  '[{"key":"A","text":"Key exchange algorithm, bulk encryption algorithm, and MAC algorithm"},{"key":"B","text":"Firewall rules, IDS signatures, and access control lists"},{"key":"C","text":"Username format, password complexity, and session timeout"},{"key":"D","text":"Certificate authority, revocation method, and key length"}]'::jsonb,
  'A',
  'A cipher suite specifies the algorithms used for key exchange (e.g., ECDHE), bulk encryption (e.g., AES-256-GCM), and message authentication (e.g., SHA-384). B is wrong because firewall rules and IDS signatures are network security controls, not cryptographic negotiation parameters. C is wrong because those are authentication policy settings, not cipher suite components. D is wrong because while related to PKI, those are certificate management elements, not cipher suite definitions.',
  'medium',
  ARRAY['cipher-suites','tls','protocol-selection','obj-1.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';

-- Q12: Obfuscation (easy)
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A software company transforms its JavaScript source code into a form that is functionally identical but extremely difficult for humans to read and reverse-engineer. This technique is called:',
  '[{"key":"A","text":"Encryption"},{"key":"B","text":"Steganography"},{"key":"C","text":"Obfuscation"},{"key":"D","text":"Hashing"}]'::jsonb,
  'C',
  'Obfuscation transforms code or data to make it difficult to understand while preserving its functionality. A is wrong because encryption transforms data to be unreadable without a key and changes the functionality until decrypted. B is wrong because steganography hides data within another medium rather than making code unreadable. D is wrong because hashing produces a fixed-length digest and is a one-way function, not a readability transformation.',
  'easy',
  ARRAY['obfuscation','software-security','obj-1.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';

-- Q13: Blockchain concepts (medium)
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization wants to create a tamper-evident audit log where each entry is cryptographically linked to the previous one, making unauthorized modification of historical records detectable. Which technology is BEST suited for this?',
  '[{"key":"A","text":"Relational database with row-level security"},{"key":"B","text":"Blockchain / distributed ledger"},{"key":"C","text":"Encrypted flat-file log with HMAC"},{"key":"D","text":"SIEM with log aggregation"}]'::jsonb,
  'B',
  'A blockchain or distributed ledger chains blocks of data using cryptographic hashes, making any alteration of a past record immediately detectable because subsequent hashes would not match. A is wrong because a relational database with RLS controls access but does not inherently provide cryptographic chaining of records. C is wrong because an HMAC verifies integrity of individual entries but does not chain entries together for tamper evidence across the entire log. D is wrong because a SIEM aggregates and correlates logs but does not provide cryptographic tamper evidence.',
  'medium',
  ARRAY['blockchain','distributed-ledger','integrity','obj-1.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';

-- Q14: Certificate lifecycle (medium)
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A web server''s TLS certificate is approaching expiration in 30 days. The security team wants to maintain service continuity. What is the correct order of steps to renew the certificate?',
  '[{"key":"A","text":"Install the new certificate, then generate a CSR, then submit to the CA"},{"key":"B","text":"Generate a new key pair and CSR, submit the CSR to the CA, install the issued certificate"},{"key":"C","text":"Contact the CA to extend the expiration date on the existing certificate"},{"key":"D","text":"Copy the existing certificate to a new file and update the expiration date manually"}]'::jsonb,
  'B',
  'The correct certificate renewal process is: generate a new key pair and Certificate Signing Request (CSR), submit the CSR to the CA for validation and issuance, then install the newly issued certificate. A is wrong because you cannot install a certificate before it is issued. C is wrong because CAs do not extend expiration dates — a new certificate must be issued. D is wrong because certificates are digitally signed by the CA and cannot be manually modified without invalidating the signature.',
  'medium',
  ARRAY['pki','certificate-lifecycle','csr','ca','obj-1.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';

-- ─── 1.1 Compare and contrast various types of security controls ───────────────

-- Q15: Security control categories — managerial (easy)
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A CISO publishes a new information security policy requiring all employees to complete annual security awareness training. This policy is BEST classified as which category of security control?',
  '[{"key":"A","text":"Technical"},{"key":"B","text":"Operational"},{"key":"C","text":"Managerial"},{"key":"D","text":"Physical"}]'::jsonb,
  'C',
  'Managerial (administrative) controls include policies, procedures, and governance frameworks established by management. A is wrong because technical controls are implemented through technology (firewalls, encryption, ACLs). B is wrong because operational controls are day-to-day procedures carried out by people (guard patrols, log reviews). D is wrong because physical controls protect tangible assets (fencing, locks, bollards).',
  'easy',
  ARRAY['security-controls','managerial-controls','obj-1.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';

-- Q16: Threat intelligence as a control (medium)
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security team subscribes to an external threat intelligence feed that provides indicators of compromise (IOCs) to proactively update firewall block lists. This practice BEST represents which combination of control category and type?',
  '[{"key":"A","text":"Managerial / corrective"},{"key":"B","text":"Technical / detective"},{"key":"C","text":"Operational / preventive"},{"key":"D","text":"Technical / preventive"}]'::jsonb,
  'D',
  'Using threat intelligence IOCs to update firewall block lists is a technical control (implemented in technology) that is preventive (blocks threats before they succeed). A is wrong because managerial controls are policies and governance, and corrective controls remediate after an incident. B is wrong because detective controls identify threats that have already occurred rather than blocking them proactively. C is wrong because operational controls are people-driven procedures, whereas firewall rules are technology-based.',
  'medium',
  ARRAY['threat-intelligence','security-controls','preventive','obj-1.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';

-- Q17: Physical security controls (medium)
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'After a tailgating incident, a data center manager installs a small room between two interlocking doors where only one door can be open at a time, ensuring each person is individually authenticated. This physical control is called:',
  '[{"key":"A","text":"Bollard"},{"key":"B","text":"Turnstile"},{"key":"C","text":"Access control vestibule (mantrap)"},{"key":"D","text":"Faraday cage"}]'::jsonb,
  'C',
  'An access control vestibule (formerly called a mantrap) is a small enclosed area with two interlocking doors that ensures only authenticated individuals pass through one at a time, preventing tailgating. A is wrong because bollards are short posts that prevent vehicle access. B is wrong because a turnstile controls pedestrian flow but does not fully enclose the individual for authentication. D is wrong because a Faraday cage blocks electromagnetic signals and is unrelated to physical access control.',
  'medium',
  ARRAY['physical-security','access-control-vestibule','mantrap','obj-1.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';

-- ─── 1.2 Summarize fundamental security concepts ──────────────────────────────

-- Q18: AAA (medium)
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A network administrator configures a RADIUS server to verify user credentials, determine which network resources each user may access, and log session duration for billing purposes. Which security framework does this implementation represent?',
  '[{"key":"A","text":"CIA triad"},{"key":"B","text":"AAA (Authentication, Authorization, Accounting)"},{"key":"C","text":"Defense in depth"},{"key":"D","text":"Zero Trust"}]'::jsonb,
  'B',
  'AAA stands for Authentication (verifying credentials), Authorization (determining allowed resources), and Accounting (logging usage for auditing or billing). A is wrong because the CIA triad addresses Confidentiality, Integrity, and Availability — security goals rather than an access control framework. C is wrong because defense in depth is a layered security strategy, not an access control model. D is wrong because Zero Trust is an architecture model that assumes no implicit trust, which is broader than the specific verify-authorize-log workflow described.',
  'medium',
  ARRAY['aaa','authentication','authorization','accounting','radius','obj-1.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';

-- Q19: Separation of duties (hard)
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A financial services company requires that the employee who initiates a wire transfer cannot be the same person who approves it. A third employee reconciles the transaction records. Which security principle is being applied?',
  '[{"key":"A","text":"Least privilege"},{"key":"B","text":"Need to know"},{"key":"C","text":"Separation of duties"},{"key":"D","text":"Job rotation"}]'::jsonb,
  'C',
  'Separation of duties divides critical tasks among multiple individuals so that no single person can complete a high-risk action alone, reducing fraud and error risk. A is wrong because least privilege limits each user to the minimum permissions needed for their role but does not require splitting a single task across people. B is wrong because need to know restricts access to information based on job requirements, not task division. D is wrong because job rotation periodically moves employees between roles to detect fraud and reduce key-person risk, but does not split a single transaction across roles.',
  'hard',
  ARRAY['separation-of-duties','access-control','obj-1.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';

-- Q20: Least privilege applied (easy)
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A help desk technician needs to reset user passwords but should not be able to create or delete user accounts. The administrator grants only the password-reset permission. Which principle is being followed?',
  '[{"key":"A","text":"Separation of duties"},{"key":"B","text":"Need to know"},{"key":"C","text":"Least privilege"},{"key":"D","text":"Mandatory access control"}]'::jsonb,
  'C',
  'Least privilege grants users only the minimum permissions necessary to perform their job functions, reducing the potential impact of accidental or malicious actions. A is wrong because separation of duties splits tasks among multiple people — here, a single person performs the task with limited rights. B is wrong because need to know restricts access to information (data), whereas this scenario restricts actions (permissions). D is wrong because mandatory access control (MAC) is a model where the system enforces access based on labels, not an administrator manually granting specific permissions.',
  'easy',
  ARRAY['least-privilege','access-control','obj-1.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';

-- Q21: CIA triad applied scenario (medium)
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A hospital''s electronic health record system goes offline during a ransomware attack, preventing doctors from accessing patient histories during emergency treatment. Which element of the CIA triad is MOST directly impacted?',
  '[{"key":"A","text":"Confidentiality"},{"key":"B","text":"Integrity"},{"key":"C","text":"Availability"},{"key":"D","text":"Non-repudiation"}]'::jsonb,
  'C',
  'Availability ensures that systems and data are accessible to authorized users when needed. A ransomware attack that takes the system offline directly impacts availability. A is wrong because confidentiality concerns unauthorized disclosure of data, which is not the primary issue when the system is simply inaccessible. B is wrong because integrity concerns unauthorized modification of data — while ransomware encrypts files, the primary impact described is inability to access the system. D is wrong because non-repudiation is not part of the CIA triad; it ensures that actions cannot be denied.',
  'medium',
  ARRAY['cia-triad','availability','ransomware','obj-1.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '1.0';
