---
layout: post
title: "You reap what you sow"
excerpt: "...  and why AI is just the messenger"
author: Philipp Zahn
categories: [Academia, Agents, Peer-Review, Software, Bugs, De-centralized Systems]
date: 2026-11-19
usemathjax: false
thanks:  I thank Bruno Marnette for helpful comments.
---

On 28 October, an anonymous AI-assisted review of 138 contributions made by Emmanuel Saez and Gabriel Zucman, was [dropped](https://saez-zucman-audit-replication.vercel.app/). It analyzed their corpus of work and flagged potential flaws, several of them potentially severe issues.

On 12 November, some of Microsoft's core services, including Teams and Outlook were hit by outages \- due to a hidden bug.

# Crescendo

Both events were mere blips in a wider torrent of events.

In the case of academia, individuals followed up by analyzing whole swaths of the literature.[^1] And for months now automated peer review systems have been deployed at scale, with tools such as [Refine](https://refine.ink/) available to individual researchers. In some evaluations, AI-generated criticisms already score higher than human reviewers' on a combined assessment of accuracy, significance, and supporting evidence.[^2]

The bugs on the 12th were followed by outages of the FAA, JPMorgan Chase, United Airlines, Apple, and the NSA.

Considered in isolation, this might be just random events.

But I wager we will see way more of both. And there are parallels between them.

# Parallels

Both streams of events \- academia vs software systems \- seem disconnected. Yet, they share a fundamental parallel: We have created systems that are way more vulnerable than most people believed. And we are relying on these systems to a degree that seems reckless.

None of this *should* come at a surprise. Take software systems where this is more obvious to the average person as everyone has had the pleasure of dealing with software that is not working.

For decades software engineers have warned about the vulnerabilities of software systems. Despite improvements in tools and engineering practices, the basic problem persists: We keep creating consequential bugs and failing to detect them before they reach production.

And to some degree we have gotten used to it. Vulnerabilities are the cost of doing business. We have accepted that.

In academia, the difficulty of replicating published findings has also been in plain sight.

The problems differ across fields and types of research. In empirical economics, rerunning the same code on the same data, testing robustness to different analytical choices, and replicating a finding with new data answer different questions. Even correct, reproducible code does not establish that a study's assumptions justify its causal conclusions.

And like software, we have gone through some iterations and improvements (providing access to data sets, testing the reproducibility of code etc) but I am not sure how much that has changed.

In the end, people soldier on.

# A Reckoning

What changes now is the cost of checking what we have already built and published. GenAI enables us to analyze software systems and the body of knowledge at a scale that was impossible before.

How much time and effort would it have taken to analyze the work by Saez and Zucman at the depth of the AI project? Obviously one can debate the quality and how it can be improved. But I think it is a safe bet that doing it at the quality level of current AI systems, it would have taken a long, long time.

Conventional peer review does not provide an exhaustive check of a paper's code, data, and reasoning. Publication is no guarantee that these have been independently verified.

The same is true for software systems. Testing costs resources. How much resources are we willing to spend on it in practice?

The new reality is that we can have AI go through all of our past and check what we have been collectively trusting. And my feeling is that in the aggregate, what we have created, might be way shakier than we would like to have believed. All the shortcuts that have slipped through, all the errors deep in the "cathedrals" we have built, can come out every day now.

Why is that?

In some sense, I would hypothesize that on an individual basis most people have had doubts about how much error correction is provided in, say, the publication process. But all this was typically expressed privately, if at all. Clearly, there is the “private truths and public lies” part,[^kuran] where what one then says in front of students, a seminar, a referee report is not the same. And then, specifically in economics, there are all the differences in power. A few departments and scientists dominate publications. With the nature of the decentralized process of how we publish, how we award resources. All views on the overall system are very local.

In short, it was basically impossible to get a full systematic grip on the "literature" and surely it cannot be so bad, right? But now, everyone can see for himself if the emperor has no clothes. 

# What is next? Harvest now \- exploit now\!

In principle, the innovation coming through AI is an opportunity to make things fundamentally better. And we see things of this already happening: Testing and formal verification in software, which both were treated as ugly ducklings,  having their time in the sun now.[^testing]

But the same tools that help us repair old weaknesses also make them easier for adversaries to find. We will be entering a wild period. The most pressing threat is the danger of basic (software) infrastructure being brought down. Our dependence on these systems is vast.

Moreover, adversaries have an incentive to actively bring down software systems. Again, crypto is the prime example as exploiting vulnerabilities often is just plain old robbery and comes with direct payoffs.

But more broadly, all the legacy systems are at stake. All what we have built on in the past is now subject to scrutiny and will be likely subject to very bad surprises.

Consider cryptographic principles which are under attack from several angles: One, just mere old school bugs in the implementation. Second, foundational principles and new results from a theoretical perspective being worked on with AI.

Academia is affected by the same threat. It is just that the stakes for individual pieces of knowledge are way lower. Most academic publishing has no direct immediate value. This is a feature and not a bug, to be clear. Academics should be targeting long term questions. Yet, if anything, the incentives in academia have spoilt it to pursue questions that grab attention at the price of rigor and scientific integrity.

Nevertheless, we will see a lot of things we took for granted to be taken down. And I cannot imagine a future, where the system continues as is. So, academia will change. How quickly, we will see.

Short term, I would expect individuals and groups of people with intent focusing on particular strands of the literature or target particular authors.

Work with policy influence, like that of Saez et al., attracts scrutiny, including from people with an axe to grind. Starting in 2011, there was a wave of investigations of politicians in Germany holding PhDs. Projects such as GuttenPlag and VroniPlag relied on crowdsourcing and focused on plagiarism rather than broader methodological criticisms. Such scrutiny can have political consequences, whatever the investigators' motives.[^3]

Expect this to spread.

# Institutional quicksand

Anything we said so far applies to knowledge work broadly. Academia and software systems are two domains where this is already visible because the current technology bears on both directly. But many other institutional arrangements will come under the same stress.

Finding problems cheaply does not make resolving them cheap. Even a flawed audit creates work: Someone has to establish what holds up. And a valid finding cannot be dismissed just because AI produced it, as `curl` maintainer Daniel Stenberg [argues from experience](https://daniel.haxx.se/blog/2026/10/22/ignore-the-slop/).

We will need new systems and new norms that support individuals and organizations in assessing these findings and deciding what follows from them.

And I think this is the real message behind the current wave of AI. All the debates about its effectiveness, risks, opportunities in research, in software systems, and also in education btw. are in the end a reckoning that we have not so well adapted to the information age.

Computers and digitalization have made it cheap to produce, distribute, and build on information. Our capacity to check the claims and dependencies we rely on has not kept pace. AI itself is an extreme example: We understand how these models are built and trained, but cannot fully explain their learned behavior or reliably anticipate where it will fail.

The organizations and the institutions we have built have not adapted to the new information age reality. Like Wile E. Coyote, they have kept on going for a while now with the hope that as long as they keep running and do not look down, they keep running.

But AI forces us to look down, everyone. It lays bare the problems that were there before. For that, it is just a messenger.

# Notes

[^kuran]: See Timur Kuran, [*Private Truths, Public Lies: The Social Consequences of Preference Falsification*](https://sites.duke.edu/timurkuran/research/books/private-truths-public-lies-the-social-consequences-of-preference-falsification/) (Harvard University Press, 1995), on how social pressures can lead people to express preferences publicly that differ from those they hold privately, concealing the extent of disagreement.

[^1]: One example in the case of astro-physics [https\://x.com/CJHandmer/status/2122609626588061816?a=PzNKPeTYYGAnkVTJIu0\&s=20](https://x.com/CJHandmer/status/2122609626588061816?a=PzNKPeTYYGAnkVTJIu0&s=20).

[^2]: The [AAAI-26 pilot](https://arxiv.org/abs/2604.13940) generated reviews for 22,977 papers in less than a day. In a separate [study of 82 Nature-family papers](https://arxiv.org/abs/2605.20668), 45 scientists assessed individual criticisms for correctness, significance, and sufficient evidence; one AI reviewing agent scored above each paper's best-rated human reviewer on the combined measure. This is evidence for specific reviewing tasks, not general superiority over human peer review. [Refine](https://refine.ink/) offers automated technical checks; a [benchmark using 100 planted errors](https://arxiv.org/abs/2611.12820) found it contributed more unique catches than any other tested system, but did not measure false positives.

[^3]: See the [University of Bayreuth's documentation of the Guttenberg case](https://www.presse.uni-bayreuth.de/de/archiv/guttenberg/index.html) and [VroniPlag's description of its collaborative work](https://vroniplag.fandom.com/de/wiki/Home). VroniPlag describes itself as a scientific project without political or commercial interests; political consequences alone do not establish political motives.

[^testing]: For a discussion about the changing status of testing see  [this interview Bruno and I did](https://youtu.be/VJGTCIxeuP0?si=30DQYwb91f2-GqeE) with Will Wilson from Antithesis.
