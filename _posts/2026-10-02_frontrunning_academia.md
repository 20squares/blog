---
layout: post
title: "Frontrunning Academia"
excerpt: "... and every other knowledge work. Credible neutral infrastructure is needed."
author: Philipp Zahn
categories: ["Academia, Agents"]
date: 2026-10-02
usemathjax: false
---

On 1 October 2026, arXiv [announced and introduced a limit of two submissions per calendar month](https://blog.arxiv.org/2026/10/01/updated-rate-limit-policy/), across all subject categories, while retaining its cap of three active submissions at any given time. 

The reason is volume. arXiv received 40,363 submissions in September 2026, up from 20,569 in September 2024. [Thomas Dietterich, chair of arXiv's Editorial Advisory Council, announced the restriction on X](https://x.com/tdietterich/status/2105751408855450078), pointing to the rapid increase in submissions. The official announcement describes the rule as a stopgap to protect volunteer moderators while arXiv improves its tools and procedures.

arXiv, for those who do not know, is an open repository for academic preprints. Scientists share their work there before journal publication. Its moderation is not journal peer review. But even this lighter process is running into capacity constraints.

# Flooding venues

This is not a single event. Journals are similarly struggling. The editors of *Accountability in Research* [report](https://doi.org/10.1080/08989621.2026.2737718) that they expect more than 1,000 original submissions in 2026, compared with 160 in 2022. They describe the strain of assessing AI-written papers and have capped submissions at four per author per year.

So are academic conferences. Consider NeurIPS, one of the major machine learning conferences. Its main track went from 12,343 submissions in 2023 to 21,575 in 2025, an increase of roughly 75% in two years.[^neurips] Its program chairs describe the difficulty of finding enough qualified reviewers and keeping decisions reliable at that scale. The numbers alone do not tell us how much of the growth came from AI. They do show the workload the system has to absorb.

![NeurIPS main-track submissions: 12,343 in 2023, 15,671 in 2024, and 21,575 in 2025.](../assetsPosts/2026-10-02-frontrunning-academia/neurips-submissions.png)

*NeurIPS main-track paper submissions, as reported by the organizers. The 2025 figure counts valid submissions. Other conference tracks are excluded. Sources and figures: [2023 fact sheet](https://media.neurips.cc/Conferences/NeurIPS2023/NeurIPS2023-Fact_Sheet.pdf), [2024 fact sheet](https://media.neurips.cc/Conferences/NeurIPS2024/NeurIPS2024-Fact_Sheet.pdf), and [2025 program chairs' report](https://blog.neurips.cc/2025/09/30/reflections-on-the-2025-review-process-from-the-program-committee-chairs/).*

This is just the beginning. Academic communities are up for a ride. 

# Scale is mandatory

Venues currently face two options. 

1. Try to ban AI. 

2. Develop new mechanisms that can work the system at scale.

If 1 is the venue's choice, good luck and so long!

Let's focus on 2 and check out two comments on X regarding arXiv's announcement.

[@TenszNeumann asks](https://x.com/TenszNeumann/status/2105772632008499399) whether the limit applies only to the submitter or also to collaborators. They point out that delays can cause several collaborative papers to become ready for submission in the same month, even for someone who would not usually submit that often.

[@JoaqunMoragaSae objects](https://x.com/JoaqunMoragaSae/status/2105765214646141215) that people posting AI slop can get a co-author to submit it for them. arXiv's own FAQ confirms that submitting a paper uses only the submitter's allowance, not the co-authors' allowances. So there is a coordination problem for legitimate authors, and a way around the limit for people willing to organize around it.

Mhm, this might not be so simple after all.

I am actually not concerned here with improving the arXiv proposal. I think it is not a suitable proposal. [Scott Kominers makes a related point](https://x.com/skominers/status/2105792318385050095): the scarce resource is moderation capacity. And a cap on papers is a blunt instrument with side effects.

I am actually way more concerned with what comes next. Because designing a system in which you can slow down the world by having restrictions on the human in the loop is one thing. Designing a system which the human is not the throttle is a very different beast.

It is not without irony that we, as a company, have been at a very similar place 6 years ago.

# Once upon a time in crypto

In 2020 and 2021 one topic dominated the Ethereum blockchain, besides Bitcoin the best known blockchain: Maximum Extractable Value (MEV). While most of the topics surrounding Ethereum are now on stablecoins, RWA tokenization and institutional adoption more broadly, and maybe, maybe from a technical perspective post-quantum readiness, MEV at that time was the key topic. 

This discussion focused on some gnarly internal problem within the blockchain. This went so far as other blockchains, then quite desparately hiring us to "get MEV going". 

Let me explain what it is, and bear with me.

In short, to get anything done on a blockchain, say Alice needs to send his USD stablecoin to Bob, this transaction needs to be recorded. What sounds simple, in fact rests on a very delicate process that by now involves a whole value chain of actors. In short, the challenge is to first verify that everything is correct in format (relatively easy) and to decide how this specific transaction should be threaded into the timeline of the blockchain (complicated). 

Now, keep in mind that at every point in time, Alice and Bob are not the only ones trying to transact. So, are Charlie and David. And, even more crucially, Ethereum not only allows such simple transactions but allows more complex programs to run - smart contracts (and so do other chains like Solana). 

So, there is a whole smorgasbrod of individual transactions that are in competition to get recorded. In blockchain lingo: These transactions need to get sequenced into a block that then becomes the history on which other new transactions can build. 

Now, here is the kickers, with transactions and smart programs running and getting sequenced, the order becomes relevant. Actually, massively important. 

Consider the following example. Alice wants to spend a USDC token against some other crypto token, say ETH (the native Ethereum token). At that time, the natural choice was an Automated Market Maker (AMM). I spare you the details but this thing is a program that waits on input (the token to be switched and information about what should be come out, here ETH). USDC goes in, ETH comes out. Like in normal market places demand and supply affect the exchange rate. So, the next person that also wants to buy ETH by giving up USDC will get a slightly different, i.e. worse, exchange rate. And the more a player sells, the stronger the price movement. 

Now, suppose Bob wants the same thing, the same transaction as Alice (he talked to Alice before and as her wants to be on Ethereum - it was 2020 after all). Now, if he comes second, he will receive a worse price, fewer ETH for the same amount of USDC. 

If the order were reversed, so Bob moving before Alice, Bob would have saved money. Now, the natural step for Bob is to ask, wait a second, if I could pay a little to be before Alice, this would make me better off. 

And this is the crux of the problem. In a chain that is constructed like Ethereum, the internal working has to decide, which transaction comes first. And the order has externalities. Also note that order mixes with temporal preferences. Charlie might have a legit concern of getting his token in time to David. So, he might be willing to pay for being before other stuff gets executed. 

Now, one last ingredient. Ethereum is permissionless, in principle everyone can submit transactions as well as smart contracts. One consequence of this is that transactions happen mostly in the open (not anymore but back then yes). And what is key, transaction that wanted to be appended to the blockchain were visible. 

The result was a sprawling ecosystem were financial actors were profitting by positioning exploitive transaction in the right place of a sequence of transactions. In fact, the very same actors that become the ones responsible for putting together blocks of transactions were then also then ones being able to exploit this by putting their own, specially structured transaction in the right spot.

Two general strategies were Frontrunning (be first in the block, respectively ahead of certain transactions) and Sandwiching - being between two transactions (or sequences of transactions).

It goes without saying that these system ran alogrithmically. Like in other financial markets no single human could manually keep up.

I spare you the sad story of how this market infrastructure developed then. But it should very clear to anyone, that this market structure and its design has massive consequences for the whole ecosystem and it functioning well.

# Back to Arxiv

The parallel should be obvious but let me spell it out. The more the submissions (think transactions) are driven by AI, the more critical become the minitua of the system. 

I think it is wortwhile to think through the process by which scientific artifacts will be "sequenced" and how robust it will be if the system runs on AI mostly. 

It is pretty evident that correctness checks will become a mandatory check ("is the transaction well formed"). This might be feasible or not under current resource constraints. Tools exist for sure. And someone else can do the math.

But it is clear, eventually, it will hit its own boundary where some other sequencing process will have to be put in place. And note this is only half of the problem. The other one, which is way more relevant for journals and conferences than Arxiv, is making decisions on merit, what is actually relevant and what not.[^iulia]

This is its own interesting problem. But let's put this to the side. 

So, if the sheer volume of contributions explodes, we need mechanisms in place that do a first filter. Now, the key question is wether this stays permissionless or not. Arxiv in principle is open  - not fully because there a constrains on who can submit and one can debate these constraints as well - but even within arxiv the problem apparently becomes already too big.

Now, the central tradeoff, which is very much known from blockchain land, is whether to have a central controller deciding or a decentralized system that needs some form of coordination ("census mechanism") in order to work. 

A centralized controller in turn, while appealing and simpler on one level has downsides as well. Well obviously, who gets the authority  (remember Bitcoin arising in 2008)? But more importantly how to guarantee its security? 

That last point might not be obvious in case of a conference venue. It is clear though in financial markets. Attack vectors are increasing because of AI, having majority mechanisms that prevent attacks might be becoming the norm. That is the a separate issue we are concerned with and you might hear from us on this in the future. 

But the same applies to conferences and journals. You might not think in terms of security but if you squnit hard enough that it is because the overall functioning of the system is at stake. 

Whatever the exact shape of conferences and journal will be in the future, and I am sure they will look very different than today, their value will depending on being able to distinguish and separate true from wrong. 

And the same will be true for almost everything.

# The ultimate resource

Academia is the canary in the coal mine. But the same will be true for almost everything. It is true for timelines on social media. X is swamped, LinkedIN is flodded with garbage.

The only resource that cannot be extended in this race, is the human attention span. So, when production process are creating abundance, we will need the mechanisms to verify true from wrong and find ways to determine the timeline that is worth visiting; be it on social media, the email you receive, or the memo you have to read. 

[^neurips]: The NeurIPS fact sheets report [12,343 main-track submissions in 2023](https://media.neurips.cc/Conferences/NeurIPS2023/NeurIPS2023-Fact_Sheet.pdf) and [15,671 in 2024](https://media.neurips.cc/Conferences/NeurIPS2024/NeurIPS2024-Fact_Sheet.pdf). The [2025 program chairs' report](https://blog.neurips.cc/2025/09/30/reflections-on-the-2025-review-process-from-the-program-committee-chairs/) gives 21,575 valid main-track submissions and discusses the resulting pressure on reviewer recruitment and decision-making. These are the three figures plotted above.

[^iulia]: Bruno Marnette and I discuss editorial judgment with Iulia Georgescu, who spent over a decade at the Nature journals and founded *Nature Reviews Physics*, in [*Taste is how we spot breakthroughs*](https://www.youtube.com/watch?v=Cwsvqplv_tY), Taste-Bench episode 15 (16 September 2026). Her account of selecting papers illustrates why deciding what deserves attention involves judgment under uncertainty. See also the [episode transcript](https://www.taste-bench.com/podcast/transcripts/15-iulia-georgescu).
