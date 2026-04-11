-- Domain 3.0: Security Architecture — Batch 2 (33 questions)
-- Objectives: 3.1-3.4
-- Topics: containers, CASB, SASE, embedded systems, HSM, TPM, secure boot, RTO/RPO, RAID

-- Q1 (easy) — Container image scanning
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A DevOps team wants to prevent deploying containers with known CVEs. Which practice BEST addresses this requirement?',
  '[{"key":"A","text":"Runtime application self-protection"},{"key":"B","text":"Container image scanning in the CI/CD pipeline"},{"key":"C","text":"Network segmentation between container pods"},{"key":"D","text":"Enabling read-only file systems on containers"}]'::jsonb,
  'B',
  'Container image scanning in the CI/CD pipeline detects known vulnerabilities before deployment, which directly prevents deploying images with CVEs. Runtime application self-protection (A) operates after deployment, not before. Network segmentation (C) limits lateral movement but does not detect CVEs in images. Read-only file systems (D) harden containers at runtime but do not identify vulnerabilities in the image itself.',
  'easy',
  ARRAY['container-security','image-scanning','ci-cd','obj-3.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q2 (medium) — Container escape
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A penetration tester gains root inside a Docker container and accesses the host filesystem. Which vulnerability class does this represent?',
  '[{"key":"A","text":"Privilege escalation via kernel exploit"},{"key":"B","text":"Container escape"},{"key":"C","text":"Server-side request forgery"},{"key":"D","text":"Insecure deserialization"}]'::jsonb,
  'B',
  'Accessing the host filesystem from within a container is a container escape — breaking out of the container''s isolation boundary. Privilege escalation (A) describes gaining higher privileges within the same system, not crossing an isolation boundary. SSRF (C) involves making requests from the server to internal resources. Insecure deserialization (D) involves exploiting object serialization flaws, which is unrelated to container isolation.',
  'medium',
  ARRAY['container-security','container-escape','docker','obj-3.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q3 (medium) — Kubernetes security
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An administrator notices pods in a Kubernetes cluster can communicate with any other pod by default. Which control should be applied to restrict east-west traffic?',
  '[{"key":"A","text":"Kubernetes NetworkPolicy"},{"key":"B","text":"A web application firewall"},{"key":"C","text":"TLS certificates on each pod"},{"key":"D","text":"Container image signing"}]'::jsonb,
  'A',
  'Kubernetes NetworkPolicy objects define rules for pod-to-pod communication, enabling microsegmentation of east-west traffic. A WAF (B) filters HTTP traffic at the application layer, typically north-south, not pod-to-pod. TLS certificates (C) encrypt traffic but do not restrict which pods can communicate. Image signing (D) verifies image integrity and provenance, not network access.',
  'medium',
  ARRAY['kubernetes','network-policy','microsegmentation','obj-3.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q4 (easy) — CASB definition
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Which solution sits between users and cloud service providers to enforce security policies such as DLP and access control?',
  '[{"key":"A","text":"SIEM"},{"key":"B","text":"CASB"},{"key":"C","text":"SOAR"},{"key":"D","text":"EDR"}]'::jsonb,
  'B',
  'A Cloud Access Security Broker (CASB) is positioned between users and cloud services to enforce organizational security policies including DLP, access control, and threat protection. A SIEM (A) aggregates and correlates logs but does not sit inline between users and cloud services. SOAR (C) automates incident response workflows. EDR (D) monitors and responds to threats on endpoints, not cloud access.',
  'easy',
  ARRAY['casb','cloud-security','obj-3.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q5 (medium) — SASE
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A company with a distributed remote workforce wants to consolidate VPN, firewall, CASB, and ZTNA into a single cloud-delivered platform. Which architecture BEST fits this requirement?',
  '[{"key":"A","text":"Software-defined WAN"},{"key":"B","text":"Secure Access Service Edge"},{"key":"C","text":"Network function virtualization"},{"key":"D","text":"Virtual private cloud peering"}]'::jsonb,
  'B',
  'SASE (Secure Access Service Edge) converges networking (SD-WAN) and security services (CASB, ZTNA, FWaaS) into a single cloud-delivered model, ideal for distributed workforces. SD-WAN (A) optimizes WAN connectivity but is only the networking component of SASE, lacking integrated security. NFV (C) virtualizes network appliances but does not provide a unified cloud-delivered security platform. VPC peering (D) connects virtual networks but does not deliver security services.',
  'medium',
  ARRAY['sase','cloud-security','ztna','obj-3.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q7 (easy) — SD-WAN
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Which technology allows an organization to route branch office traffic over multiple transport links (MPLS, broadband, LTE) using centralized policy management?',
  '[{"key":"A","text":"SD-WAN"},{"key":"B","text":"VLAN trunking"},{"key":"C","text":"BGP route reflector"},{"key":"D","text":"MPLS label switching"}]'::jsonb,
  'A',
  'SD-WAN abstracts the underlying transport (MPLS, broadband, LTE) and uses centralized policies to route traffic optimally across multiple links. VLAN trunking (B) carries multiple VLANs over a single link but does not manage WAN routing. BGP route reflector (C) is a routing optimization within BGP, not a WAN management overlay. MPLS label switching (D) is one of the transports SD-WAN can leverage, not a centralized policy management solution.',
  'easy',
  ARRAY['sd-wan','networking','obj-3.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q8 (hard) — Serverless security
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A development team migrates an application to serverless functions. The security team is concerned about overly permissive execution roles. Which control is MOST important to implement first?',
  '[{"key":"A","text":"Apply least-privilege IAM roles per function"},{"key":"B","text":"Deploy a WAF in front of the API gateway"},{"key":"C","text":"Enable encryption at rest on the function code"},{"key":"D","text":"Implement container image scanning"}]'::jsonb,
  'A',
  'In serverless architectures, each function should have a least-privilege IAM role granting only the permissions it needs, directly addressing the concern about overly permissive roles. A WAF (B) protects against web attacks but does not limit function permissions. Encryption at rest (C) protects stored data but does not address execution privilege. Container image scanning (D) applies to container workloads, not serverless functions.',
  'hard',
  ARRAY['serverless','iam','least-privilege','obj-3.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q9 (easy) — Embedded systems
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Which characteristic makes embedded systems in manufacturing environments especially difficult to secure?',
  '[{"key":"A","text":"They use high-bandwidth network connections"},{"key":"B","text":"They often run proprietary firmware with long lifecycles and infrequent updates"},{"key":"C","text":"They require multi-factor authentication by default"},{"key":"D","text":"They are always connected to the public internet"}]'::jsonb,
  'B',
  'Embedded systems often run proprietary firmware with extended lifecycles of 10-20 years and receive infrequent security updates, making them difficult to patch. They typically use low-bandwidth connections (A is incorrect). Most embedded systems lack MFA capabilities (C is incorrect). Many embedded systems operate on isolated networks without internet access (D is incorrect).',
  'easy',
  ARRAY['embedded-systems','firmware','obj-3.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q11 (medium) — RTOS
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A medical device manufacturer selects an RTOS for a patient-monitoring system. What is the PRIMARY security consideration when choosing this operating system?',
  '[{"key":"A","text":"Support for graphical user interfaces"},{"key":"B","text":"Deterministic response times must not be compromised by security controls"},{"key":"C","text":"Ability to run standard antivirus software"},{"key":"D","text":"Native support for cloud-based management"}]'::jsonb,
  'B',
  'An RTOS must deliver deterministic, time-bounded responses. Security controls must not introduce latency that could cause the system to miss deadlines, which is critical for patient safety. GUI support (A) is a usability concern, not a security consideration. Standard antivirus (C) is generally too resource-intensive for RTOS environments. Cloud management (D) is not a primary security consideration for embedded medical devices.',
  'medium',
  ARRAY['rtos','embedded-systems','medical-devices','obj-3.2']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q12 (medium) — API gateway
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization exposes dozens of microservices through public APIs. Which component provides centralized authentication, rate limiting, and request validation for all API endpoints?',
  '[{"key":"A","text":"Reverse proxy"},{"key":"B","text":"API gateway"},{"key":"C","text":"Load balancer"},{"key":"D","text":"Service mesh sidecar"}]'::jsonb,
  'B',
  'An API gateway provides centralized authentication, rate limiting, request validation, and routing for APIs — purpose-built for managing API traffic. A reverse proxy (A) can handle some of these functions but lacks native API management features like rate limiting and request schema validation. A load balancer (C) distributes traffic but does not perform authentication or request validation. A service mesh sidecar (D) handles service-to-service communication, not external API management.',
  'medium',
  ARRAY['api-gateway','microservices','obj-3.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q13 (hard) — Service mesh
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security architect wants to enforce mutual TLS between all microservices without modifying application code. Which technology achieves this?',
  '[{"key":"A","text":"API gateway with TLS termination"},{"key":"B","text":"Service mesh with sidecar proxies"},{"key":"C","text":"Network-level IPsec tunnels between hosts"},{"key":"D","text":"Application-level certificate pinning"}]'::jsonb,
  'B',
  'A service mesh deploys sidecar proxies alongside each service that handle mTLS transparently, requiring no application code changes. An API gateway (A) typically terminates TLS at the edge, not between internal services. IPsec tunnels (C) encrypt at the network layer but require infrastructure configuration per host and don''t provide per-service identity. Certificate pinning (D) requires application code modification, violating the stated requirement.',
  'hard',
  ARRAY['service-mesh','mtls','microservices','obj-3.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q14 (medium) — ZTNA vs VPN
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Compared to a traditional VPN, what is the PRIMARY advantage of ZTNA for remote access?',
  '[{"key":"A","text":"It eliminates the need for user authentication"},{"key":"B","text":"It grants access only to specific applications after verifying identity and device posture"},{"key":"C","text":"It provides higher bandwidth for file transfers"},{"key":"D","text":"It uses IPsec instead of TLS for stronger encryption"}]'::jsonb,
  'B',
  'ZTNA grants per-application access based on continuous identity and device posture verification, following least-privilege principles. Traditional VPNs typically grant broad network access once connected. ZTNA still requires authentication (A is incorrect). Bandwidth (C) depends on network infrastructure, not the access model. ZTNA commonly uses TLS, and encryption strength is not its differentiator (D is incorrect).',
  'medium',
  ARRAY['ztna','zero-trust','vpn','obj-3.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q15 (hard) — Shared responsibility model
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A company runs a web application on an IaaS VM. A data breach occurs because the guest OS was missing critical patches. Under the shared responsibility model, who is accountable?',
  '[{"key":"A","text":"The cloud provider, because they manage the infrastructure"},{"key":"B","text":"The customer, because guest OS patching is their responsibility in IaaS"},{"key":"C","text":"Both parties share equal accountability"},{"key":"D","text":"Neither party, because patching is handled by the hypervisor"}]'::jsonb,
  'B',
  'In IaaS, the customer is responsible for the guest OS, including patching, configuration, and security. The cloud provider manages the underlying infrastructure (hardware, hypervisor, network). The provider manages infrastructure, not guest OS (A is incorrect). Responsibility is clearly divided, not equally shared (C is incorrect). The hypervisor does not patch guest operating systems (D is incorrect).',
  'hard',
  ARRAY['shared-responsibility','iaas','cloud-security','obj-3.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q16 (medium) — CSPM
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization wants to continuously monitor its cloud environments for misconfigurations such as publicly exposed storage buckets and overly permissive security groups. Which solution is BEST suited?',
  '[{"key":"A","text":"CWPP"},{"key":"B","text":"CSPM"},{"key":"C","text":"CASB"},{"key":"D","text":"SIEM"}]'::jsonb,
  'B',
  'Cloud Security Posture Management (CSPM) continuously scans cloud environments for misconfigurations like open storage buckets and permissive security groups. CWPP (A) focuses on protecting cloud workloads (VMs, containers) at runtime, not infrastructure configuration. CASB (C) controls user access to cloud services, not infrastructure posture. SIEM (D) correlates security events but does not proactively scan for cloud misconfigurations.',
  'medium',
  ARRAY['cspm','cloud-security','misconfiguration','obj-3.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q17 (medium) — CWPP
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A security team needs runtime protection for workloads running across VMs, containers, and serverless functions in multiple clouds. Which platform addresses this need?',
  '[{"key":"A","text":"CSPM"},{"key":"B","text":"CASB"},{"key":"C","text":"CWPP"},{"key":"D","text":"MDM"}]'::jsonb,
  'C',
  'Cloud Workload Protection Platform (CWPP) provides runtime security for workloads including VMs, containers, and serverless functions across cloud environments. CSPM (A) monitors cloud configuration posture, not workload runtime behavior. CASB (B) governs user access to cloud services. MDM (D) manages mobile devices, not cloud workloads.',
  'medium',
  ARRAY['cwpp','cloud-security','workload-protection','obj-3.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q18 (medium) — Microsegmentation
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'After a ransomware incident spread laterally across the data center, the CISO mandates limiting blast radius by restricting traffic between individual workloads. Which technique achieves this?',
  '[{"key":"A","text":"VLAN segmentation at the switch level"},{"key":"B","text":"Microsegmentation with host-based policies"},{"key":"C","text":"Deploying a perimeter firewall with stricter rules"},{"key":"D","text":"Implementing NAT for all internal hosts"}]'::jsonb,
  'B',
  'Microsegmentation applies granular, host-based security policies to individual workloads, restricting lateral movement far more precisely than traditional network segmentation. VLAN segmentation (A) operates at the network level and is too coarse for workload-level isolation. Perimeter firewalls (C) protect north-south traffic but do not control east-west traffic within the data center. NAT (D) translates addresses for privacy but does not enforce access control between workloads.',
  'medium',
  ARRAY['microsegmentation','zero-trust','lateral-movement','obj-3.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q19 (easy) — Reverse proxy
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Which network appliance sits in front of web servers, hides their IP addresses from external clients, and can perform TLS offloading?',
  '[{"key":"A","text":"Forward proxy"},{"key":"B","text":"Reverse proxy"},{"key":"C","text":"Layer 3 switch"},{"key":"D","text":"IDS sensor"}]'::jsonb,
  'B',
  'A reverse proxy sits in front of backend servers, hides their addresses from clients, and can offload TLS processing. A forward proxy (A) sits in front of clients and forwards their requests outbound, not in front of servers. A Layer 3 switch (C) routes traffic between subnets but does not provide proxy or TLS offloading services. An IDS sensor (D) monitors traffic for threats but does not proxy or terminate connections.',
  'easy',
  ARRAY['reverse-proxy','network-appliances','tls','obj-3.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q20 (easy) — 802.1X port security
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Which standard provides port-based network access control by requiring devices to authenticate before being granted access to the LAN?',
  '[{"key":"A","text":"802.11ac"},{"key":"B","text":"802.1X"},{"key":"C","text":"802.3af"},{"key":"D","text":"802.1Q"}]'::jsonb,
  'B',
  '802.1X is the IEEE standard for port-based network access control, requiring authentication (typically via RADIUS) before a device can access the network. 802.11ac (A) is a wireless networking standard for speed/bandwidth. 802.3af (C) is the Power over Ethernet standard. 802.1Q (D) defines VLAN tagging on Ethernet frames.',
  'easy',
  ARRAY['802.1x','port-security','nac','obj-3.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q22 (hard) — WPA Enterprise vs Personal
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A hospital needs to ensure individual accountability for wireless access and automatically revoke access when an employee leaves. Which wireless security configuration BEST meets these requirements?',
  '[{"key":"A","text":"WPA3-Personal with a complex passphrase rotated monthly"},{"key":"B","text":"WPA3-Enterprise with 802.1X and RADIUS tied to Active Directory"},{"key":"C","text":"WPA2-Personal with MAC address filtering"},{"key":"D","text":"Open network with a captive portal requiring credentials"}]'::jsonb,
  'B',
  'WPA3-Enterprise with 802.1X and RADIUS integrated with Active Directory provides per-user authentication and automatic revocation when accounts are disabled. WPA3-Personal (A) uses a shared passphrase that cannot provide individual accountability or automatic revocation. WPA2-Personal with MAC filtering (C) provides neither individual accountability nor automatic revocation, and MAC addresses can be spoofed. An open network with a captive portal (D) does not encrypt wireless traffic and is unsuitable for healthcare environments.',
  'hard',
  ARRAY['wpa-enterprise','802.1x','radius','wireless-security','obj-3.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q23 (medium) — EAP types
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization requires mutual authentication between the wireless client and the RADIUS server, using certificates on both sides. Which EAP type satisfies this requirement?',
  '[{"key":"A","text":"EAP-FAST"},{"key":"B","text":"PEAP"},{"key":"C","text":"EAP-TLS"},{"key":"D","text":"EAP-TTLS"}]'::jsonb,
  'C',
  'EAP-TLS requires certificates on both the client and the server, providing mutual authentication. EAP-FAST (A) uses a Protected Access Credential, not client certificates. PEAP (B) uses a server certificate and client credentials (username/password), not client certificates. EAP-TTLS (D) also uses a server certificate with client credentials inside the tunnel, not client certificates.',
  'medium',
  ARRAY['eap-tls','wireless-security','radius','obj-3.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q24 (medium) — DNSSEC
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization discovers that attackers are spoofing DNS responses to redirect users to malicious sites. Which technology validates the authenticity of DNS records using digital signatures?',
  '[{"key":"A","text":"DNS over HTTPS"},{"key":"B","text":"DNSSEC"},{"key":"C","text":"DNS sinkhole"},{"key":"D","text":"Split-horizon DNS"}]'::jsonb,
  'B',
  'DNSSEC uses digital signatures to validate the authenticity and integrity of DNS responses, preventing DNS spoofing. DNS over HTTPS (A) encrypts DNS queries for privacy but does not validate record authenticity. A DNS sinkhole (C) redirects malicious domain lookups to a controlled address but does not authenticate DNS records. Split-horizon DNS (D) provides different responses based on the source network and has no authentication function.',
  'medium',
  ARRAY['dnssec','dns-security','obj-3.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q25 (medium) — DNS sinkhole
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'The security team wants to prevent malware on the internal network from reaching known command-and-control domains. Which DNS-based technique blocks these communications?',
  '[{"key":"A","text":"DNSSEC validation"},{"key":"B","text":"Dynamic DNS registration"},{"key":"C","text":"DNS sinkhole"},{"key":"D","text":"Recursive DNS caching"}]'::jsonb,
  'C',
  'A DNS sinkhole intercepts DNS queries for known malicious domains and returns a controlled IP address, effectively blocking malware C2 communications. DNSSEC (A) validates record authenticity but does not block specific domains. Dynamic DNS (B) maps changing IP addresses to hostnames and has no blocking capability. Recursive DNS caching (D) improves query performance but does not filter malicious domains.',
  'medium',
  ARRAY['dns-sinkhole','dns-security','malware','obj-3.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q26 (easy) — HSM
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A financial institution needs tamper-resistant hardware to generate, store, and manage cryptographic keys used for transaction signing. Which device meets this requirement?',
  '[{"key":"A","text":"TPM"},{"key":"B","text":"HSM"},{"key":"C","text":"Smart card"},{"key":"D","text":"USB security key"}]'::jsonb,
  'B',
  'A Hardware Security Module (HSM) is a dedicated, tamper-resistant hardware device designed for managing cryptographic keys at scale, commonly used in enterprise and financial environments. A TPM (A) is a chip embedded in a motherboard for platform integrity, not enterprise key management. A smart card (C) stores keys for individual authentication, not high-volume transaction signing. A USB security key (D) provides individual authentication factors, not enterprise key management.',
  'easy',
  ARRAY['hsm','cryptography','key-management','obj-3.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q27 (easy) — TPM
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Which hardware component embedded in a laptop''s motherboard stores encryption keys and supports full-disk encryption solutions like BitLocker?',
  '[{"key":"A","text":"HSM"},{"key":"B","text":"GPU"},{"key":"C","text":"TPM"},{"key":"D","text":"NIC"}]'::jsonb,
  'C',
  'The Trusted Platform Module (TPM) is a chip on the motherboard that securely stores encryption keys, platform measurements, and supports disk encryption tools like BitLocker. An HSM (A) is an external or rack-mounted device for enterprise key management, not embedded in laptops. A GPU (B) processes graphics, not cryptographic key storage. A NIC (D) handles network connectivity.',
  'easy',
  ARRAY['tpm','encryption','bitlocker','obj-3.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q28 (hard) — Secure boot and measured boot
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An administrator enables both secure boot and measured boot on company laptops. What is the key difference between these two processes?',
  '[{"key":"A","text":"Secure boot encrypts the boot partition; measured boot decrypts it"},{"key":"B","text":"Secure boot verifies signatures and blocks unauthorized code; measured boot records hashes for later attestation"},{"key":"C","text":"Secure boot applies only to BIOS systems; measured boot applies only to UEFI"},{"key":"D","text":"Secure boot requires a TPM; measured boot does not"}]'::jsonb,
  'B',
  'Secure boot validates digital signatures of boot components and prevents unsigned/tampered code from executing. Measured boot records cryptographic hashes of each boot component into the TPM for remote attestation, but does not block execution. Secure boot does not encrypt the boot partition (A is incorrect). Both work with UEFI firmware (C is incorrect). Measured boot requires a TPM to store measurements, while secure boot uses UEFI firmware keys (D has it reversed).',
  'hard',
  ARRAY['secure-boot','measured-boot','tpm','attestation','obj-3.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q29 (medium) — Remote attestation
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'Before granting network access, a security policy requires verifying that a device''s boot process has not been tampered with. Which mechanism provides this assurance?',
  '[{"key":"A","text":"Full-disk encryption verification"},{"key":"B","text":"Remote attestation using TPM-stored measurements"},{"key":"C","text":"Host-based intrusion detection"},{"key":"D","text":"Endpoint DLP scanning"}]'::jsonb,
  'B',
  'Remote attestation uses TPM-stored boot measurements to cryptographically prove to a remote server that the device booted with trusted components. Full-disk encryption (A) protects data at rest but does not verify boot integrity. Host-based IDS (C) monitors for threats at runtime, not during boot verification. DLP scanning (D) prevents data leakage, not boot integrity verification.',
  'medium',
  ARRAY['attestation','tpm','measured-boot','obj-3.1']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q30 (easy) — RAID levels
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A file server requires fault tolerance with the ability to survive a single disk failure while maximizing usable storage capacity. Which RAID level is MOST appropriate?',
  '[{"key":"A","text":"RAID 0"},{"key":"B","text":"RAID 1"},{"key":"C","text":"RAID 5"},{"key":"D","text":"RAID 10"}]'::jsonb,
  'C',
  'RAID 5 uses distributed parity across all disks, surviving one disk failure while using only one disk''s worth of capacity for parity — maximizing usable storage. RAID 0 (A) provides striping with no redundancy and cannot survive any disk failure. RAID 1 (B) mirrors disks, surviving a failure but using 50% of capacity for redundancy. RAID 10 (D) combines striping and mirroring, providing excellent performance and fault tolerance but using 50% capacity for mirrors.',
  'easy',
  ARRAY['raid','availability','storage','obj-3.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q31 (medium) — Geographic dispersion
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A company wants to ensure business continuity even if a natural disaster destroys an entire data center region. Which resilience strategy addresses this?',
  '[{"key":"A","text":"Deploying redundant servers in the same facility"},{"key":"B","text":"Geographic dispersion of data centers across multiple regions"},{"key":"C","text":"Increasing RAID level on storage arrays"},{"key":"D","text":"Implementing daily differential backups"}]'::jsonb,
  'B',
  'Geographic dispersion places infrastructure in different physical regions so a regional disaster cannot take down all operations. Redundant servers in the same facility (A) do not protect against site-wide disasters. Higher RAID levels (C) protect against disk failures, not regional disasters. Differential backups (D) protect data but do not ensure service continuity during a regional outage unless stored offsite with recovery infrastructure.',
  'medium',
  ARRAY['geographic-dispersion','resilience','disaster-recovery','obj-3.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q32 (medium) — Platform diversity
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'An organization runs all its web servers on the same OS version. A zero-day exploit for that OS takes down every server simultaneously. Which resilience strategy would have mitigated this?',
  '[{"key":"A","text":"Capacity planning"},{"key":"B","text":"Platform diversity"},{"key":"C","text":"Load balancing"},{"key":"D","text":"Full backup schedule"}]'::jsonb,
  'B',
  'Platform diversity means using different operating systems or technology stacks so a single vulnerability does not affect all systems simultaneously. Capacity planning (A) ensures sufficient resources but does not address single-point-of-failure from monoculture. Load balancing (C) distributes traffic but if all servers share the same vulnerability, all can be compromised. Full backups (D) aid recovery but do not prevent simultaneous compromise.',
  'medium',
  ARRAY['platform-diversity','resilience','obj-3.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q33 (hard) — Capacity planning
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'During a product launch, a web application crashes because the database connection pool is exhausted. Which proactive measure would have BEST prevented this outage?',
  '[{"key":"A","text":"Implementing RAID 10 on the database server"},{"key":"B","text":"Conducting capacity planning with load testing before the launch"},{"key":"C","text":"Enabling geographic dispersion of the web tier"},{"key":"D","text":"Switching to asynchronous replication"}]'::jsonb,
  'B',
  'Capacity planning with load testing identifies resource bottlenecks (like connection pool limits) before they cause production outages. RAID 10 (A) improves disk performance and fault tolerance but does not address connection pool exhaustion. Geographic dispersion (C) adds regional resilience but does not solve resource sizing at a single site. Asynchronous replication (D) aids disaster recovery but does not prevent connection pool exhaustion under load.',
  'hard',
  ARRAY['capacity-planning','resilience','load-testing','obj-3.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q34 (hard) — RTO vs RPO
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A company''s disaster recovery plan specifies an RPO of 1 hour and an RTO of 4 hours. The backup system runs nightly full backups at midnight. Does this configuration meet the stated objectives?',
  '[{"key":"A","text":"Yes, because nightly backups ensure data is always recoverable"},{"key":"B","text":"No, because nightly backups could lose up to 24 hours of data, exceeding the 1-hour RPO"},{"key":"C","text":"Yes, because the RTO of 4 hours allows time to restore from the nightly backup"},{"key":"D","text":"No, because the RTO should always be shorter than the RPO"}]'::jsonb,
  'B',
  'With nightly backups, up to 24 hours of data could be lost in a worst-case scenario, far exceeding the 1-hour RPO. To meet a 1-hour RPO, backups or replication must occur at least hourly. Option A is incorrect because nightly backups do not guarantee data loss within 1 hour. Option C correctly identifies the RTO concern but ignores the RPO violation, which is the critical failure. Option D is incorrect because RTO and RPO are independent metrics — there is no rule that one must be shorter than the other.',
  'hard',
  ARRAY['rto','rpo','disaster-recovery','backup','obj-3.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q35 (medium) — Differential backup scenario
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A full backup runs Sunday night. Differential backups run Monday through Saturday. A server fails on Thursday afternoon. Which backup sets are needed for the FASTEST restore?',
  '[{"key":"A","text":"Sunday full + Monday incremental + Tuesday incremental + Wednesday incremental"},{"key":"B","text":"Sunday full + Wednesday differential"},{"key":"C","text":"Only the Wednesday differential"},{"key":"D","text":"Sunday full + Monday differential + Tuesday differential + Wednesday differential"}]'::jsonb,
  'B',
  'A differential backup contains all changes since the last full backup. To restore, you need only the most recent full backup (Sunday) and the most recent differential (Wednesday). Option A describes an incremental restore process, which requires every incremental since the full backup. Option C omits the full backup, which is required as the base. Option D applies every differential, which is unnecessary since each differential already contains all changes since Sunday.',
  'medium',
  ARRAY['differential-backup','backup','disaster-recovery','obj-3.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

-- Q36 (medium) — Synchronous vs asynchronous replication
INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  'A financial trading platform requires zero data loss if the primary database fails. Which replication type meets this requirement?',
  '[{"key":"A","text":"Asynchronous replication"},{"key":"B","text":"Synchronous replication"},{"key":"C","text":"Snapshot-based replication"},{"key":"D","text":"Log shipping with a 15-minute delay"}]'::jsonb,
  'B',
  'Synchronous replication writes data to both primary and replica before acknowledging the transaction, ensuring zero data loss (RPO = 0). Asynchronous replication (A) acknowledges writes before replicating, which can lose recent transactions. Snapshot-based replication (C) captures point-in-time copies at intervals, allowing data loss between snapshots. Log shipping with a delay (D) inherently introduces a 15-minute window of potential data loss.',
  'medium',
  ARRAY['replication','synchronous','rpo','availability','obj-3.4']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '3.0';

