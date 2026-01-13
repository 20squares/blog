---
layout: post
title: "The Compliance Clock Started ... in 2024"
excerpt: "Post-quantum cryptography is becoming a legal exposure, not just a technical curiosity"
author: Fabrizio Genovese, Philipp Zahn
categories: Cryptography, Compliance
date: 2026-01-12
usemathjax: false
thanks: "<b>A note before we begin: This post discusses regulatory frameworks and compliance considerations, but it isn't legal advice. This is our interpretation. If you're making decisions about your organization's cryptographic posture, talk to your lawyers.</b>"
---

At some point, every organization we talk to about cryptography says some version of the same thing: "Quantum computers don't exist yet. We have time."

This assumption is increasingly risky. Not because of physics. When cryptographically relevant quantum computers will arrive is genuinely uncertain. The risk is legal.

In 2024, two things happened. The EU Commission issued its PQC Recommendation in April.[^1] NIST finalized its post-quantum cryptographic standards in August.[^2] Together, these events are reshaping what "state of the art" means under NIS2 and DORA. And that phrase has teeth.

If your organization falls under either framework — critical infrastructure, financial services, healthcare, digital infrastructure — and you're still deploying systems with only classical cryptography, you have a compliance exposure that will likely intensify.

# The Legal Ground Is Shifting

To understand why 2024 matters, start with the regulatory text.

Both NIS2 and DORA require security measures that reflect the "state of the art." This isn't aspirational guidance. It's a legal standard that regulators use to assess adequacy, and it evolves as authoritative bodies publish updated standards.

NIS2 Article 21(2)(h) mandates "policies and procedures regarding the use of cryptography and, where appropriate, encryption." DORA Article 9 requires financial entities to ensure "data confidentiality" and minimize "unauthorized access." Neither regulation specifies which algorithms to use. They don't have to. The definition of adequate security shifts as the consensus on best practice shifts.

Think about this: Before April 2024, you could plausibly argue that RSA-2048 or classical elliptic curve cryptography met the state-of-the-art threshold. After the EU PQC Recommendation and NIST's standardization of ML-KEM (Kyber) and ML-DSA (Dilithium), that argument weakens. Continuing to deploy new systems with only classical cryptography and without a documented migration plan creates a risk management gap that regulators may increasingly scrutinize.

Now, to be clear: no regulator has yet issued enforcement actions requiring post-quantum cryptography. Mainstream regulatory interpretation currently treats PQC as forward-planning rather than immediate obligation. Explicit mandatory timelines have not been issued.

But the legal definition of "state of the art" is not static. Organizations that wait for explicit mandates may find themselves explaining why they ignored authoritative guidance that was publicly available years earlier.

Here is where it gets personal (for executives, anyway): The regulations explicitly tie adequacy to liability. Under NIS2 Article 20, members of the management body are personally responsible for approving cybersecurity risk strategies. Under DORA Article 5, that responsibility extends to ICT risk management. Boards that approve systems relying on cryptography with known long-term vulnerabilities - without documented risk assessment and migration planning — expose themselves to regulatory scrutiny, potentially including temporary bans from management roles.[^3]

# Harvest Now, Decrypt Later

The standard objection goes something like this: "Quantum computers don't exist. Why should we act now?"

The answer is "Harvest Now, Decrypt Later" (HNDL). Adversaries with patience and storage capacity can intercept encrypted data today, archive it, and wait for cryptographically relevant quantum computers to arrive. When they do, the adversary decrypts everything at once.

The urgency of HNDL depends on two variables: how long your data must remain confidential, and when quantum computers capable of breaking current encryption will arrive. If your confidentiality requirement is five years and quantum arrives in fifteen, you have breathing room. If your confidentiality requirement is twenty years and quantum arrives in ten, the data is already compromised. The breach happened the day it was intercepted.

This threat model applies most urgently to data with long confidentiality requirements: health records, state secrets, strategic communications, merger negotiations, intellectual property with multi-decade value. It applies less urgently to session-level encryption or data with short-lived sensitivity. Not all encrypted data faces equivalent HNDL exposure.[^4]

HNDL also assumes well-resourced adversaries: nation-states or sophisticated actors with the storage capacity and strategic patience to archive intercepted traffic for years. Most organizations are not targeted by such adversaries. But organizations handling high-value, long-lived confidential data should assume they might be.

The bottom line: DORA's mandate for "data confidentiality" doesn't come with an asterisk for threats that haven't fully materialized. If you cannot demonstrate that your encryption will protect data for its required confidentiality period, your risk management framework has a gap.

# The First Step You're Probably Missing

Most organizations contemplating PQC migration jump straight to implementation questions. Which algorithms? Which libraries? Which vendors?

This is the wrong starting point.

You cannot migrate what you cannot find.

Before any migration planning, you need a cryptographic inventory, sometimes called a Cryptography Bill of Materials (CBOM). This inventory catalogs every cryptographic asset in your environment: where keys are stored, which algorithms are in use, which certificates protect which systems, and which third-party dependencies embed their own cryptographic choices.

NIS2 Article 21(2)(i) requires asset management. DORA Article 6 mandates comprehensive ICT risk identification. A complete cryptographic inventory isn't just a useful precursor to migration; it's a regulatory requirement you may already be underperforming.

Building this inventory is unglamorous work. It involves auditing legacy systems, parsing vendor documentation, and discovering cryptographic dependencies you didn't know you had. But without it, your migration plan is fiction. You'll miss systems. You'll leave vulnerabilities in place. And when regulators ask how you're addressing the quantum threat, you won't have a defensible answer.

# Your Supply Chain Is Your Attack Surface

Even a perfect internal cryptographic inventory isn't sufficient. Under both NIS2 and DORA, your security posture includes your suppliers.

NIS2 Article 21(2)(d) explicitly requires assessment of supply chain security. DORA Article 28 mandates a "Register of Information" documenting all ICT third-party providers. If your firewall vendor, cloud provider, or payment processor has no post-quantum roadmap, that's a supply chain risk you're required to document and address.

This puts organizations in an uncomfortable position. Your quantum readiness depends partly on decisions made by vendors you don't control. But "we're waiting for our vendors" is not a compliance strategy. You need to know, documentably know, where your critical ICT suppliers stand on PQC. If they don't have a roadmap, that fact belongs in your risk register.

For financial entities, DORA Article 28(8) adds another layer: you must demonstrate that you can exit a critical provider without service disruption. If your cloud infrastructure runs on cryptographic primitives with no migration path, your exit strategy may be legally deficient.


# What This Means in Practice

The regulatory signal is clear, even if explicit mandates remain forthcoming.

**Constitute your cryptographic inventory.** You cannot make rational migration decisions—or satisfy asset management requirements—without knowing what you have. This is prerequisite work that pays dividends regardless of quantum timelines.

**Document your position.** If you're using classical cryptography, you need a written cryptography policy that explains your current choices and your migration timeline. "We'll get to it eventually" is not a policy. A dated, board-approved plan is.

**Assess your supply chain.** Identify which vendors handle your critical cryptographic dependencies and determine whether they have PQC roadmaps. Document the risks if they don't. 

**Ensure your board understands the exposure.** The personal liability provisions in NIS2 and DORA aren't abstractions. Executives who approve risk strategies without understanding the quantum dimension are accepting risks they may not fully appreciate.

**Recognize that migration is complex.** When you do move to implementation, you'll encounter hybrid deployment schemes, performance constraints, hardware security module dependencies, and protocol-level considerations across TLS, IPsec, and code-signing infrastructure. The inventory and documentation work positions you to navigate that complexity.

# Why We Care

We have been thinking about post-quantum transitions for a while now. Through [NeverLocal](https://neverlocal.com/), a joint venture we founded with partners from Oxford, we are working on the transition of blockchains into the post-quantum world — getting involved early, while the structure is still forming.

The pattern we see in crypto is the same pattern playing out in regulated industries: an expanding causal cone of compliance requirements, where decisions made today constrain options available tomorrow. Organizations that treat PQC as a 2030 problem will discover, around 2027, that their options have narrowed considerably.

The arrival of quantum computing remains uncertain. But the regulatory framework isn't waiting for that question to be settled. The legal definition of adequate security is already evolving and prudent organizations are evolving with it.

---

[^1]: EU Commission PQC Recommendation, C(2024) 2490 final, April 2024.
[^2]: NIST Post-Quantum Cryptography Standards, August 2024 (FIPS 203, FIPS 204, FIPS 205).
[^3]: See NIS2 Directive (EU 2022/2555), Articles 20, 21; DORA Regulation (EU 2022/2554), Articles 5, 6, 9, 28.
[^4]: The academic literature on HNDL is extensive. For a practical threat assessment, the key variables are: data sensitivity lifetime, adversary capability assumptions, and interception feasibility. Most compliance frameworks don't require you to defend against every theoretical adversary—but they do require you to document your threat model.
