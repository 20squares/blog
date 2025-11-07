---
layout: post
title: "Part 1: Tokenizing Debt - Intro"
author: Philipp Zahn
categories: ["DeFi", "Tokenization", "Fintech", "Blockchain", "Asset-Backed Securities"]
excerpt: "Our journey into short-term debt tokenization."
usemathjax: false
thanks: ""
---

Tokenization has emerged as a dominant theme in blockchain applications, with new asset classes being brought on-chain daily. While stablecoins are the dominant asset, RWA tokenizations see massive growth. Within this class, debt tokenization represents a particularly significant development. Both government debt mostly in form of treasuries as well as private credit debt (various categories) see rapid growth.[^1]

In the next weeks we will be releasing a series of posts that examine a specific segment of debt tokenization that has received less attention: short-term B2B debt. While other forms of tokenization capture headlines, this particular market presents unique challenges and opportunities that warrant detailed examination.

## TradFi Private Debt

The scale and growth of TradFi private debt markets remain underappreciated outside specialized financial circles. Private debt has evolved from a niche alternative investment to a major asset class, with assets under management reaching trillions with further projected growth.[^2] This expansion reflects both recognition of private debt as an attractive asset class and structural changes in traditional lending markets.

The transformation stems primarily from the regulatory response to the 2007-2008 financial crisis. Basel III and subsequent regulations fundamentally altered banks' capital requirements and risk appetites, driving a systematic withdrawal from traditional lending activities, particularly to SMEs. This regulatory-driven disintermediation created a lending vacuum that private debt funds have moved to fill. And this despite the fact that in parallel tighter regulation was imposed on these very investments vehicles in parts of the world (the EU as usual being in the lead when it comes to regulation; here through the AIFMD[^3])

## SME Under Duress

The consequences of this structural shift are particularly acute for European SMEs, which historically relied more heavily on bank financing than their American counterparts. These enterprises now face significant liquidity constraints at a time when economic uncertainty has intensified scrutiny of corporate health. The proliferation of so-called "zombie companies"—enterprises surviving solely through continuous refinancing—highlights the severity of the situation.

This financing gap represents both a crisis and an opportunity. Traditional solutions have proven insufficient, while pure crypto-native approaches often fail to address the fundamental requirements of real-world debt markets. The solution requires sophisticated bridge infrastructure connecting off-chain economic activity with on-chain financial primitives.

## Our Entry Point

How did we enter this domain? Very simple: as hired guns. One part of 20squares, that we provide as a specialized service for clients, is **incentive design and market design** in the context of blockchain protocols.

As usual in this line of work, some designs get implemented, some don't, and some are still under development (like this one) - it's the client's call after all.[^4]

To make a long story short, in 2024 we were engaged "to develop a token for invoices". The timing was perfect. Our MEV-related work provided insights into market microstructure, while the broader tokenization trend had matured sufficiently to support serious infrastructure development. What began as a straightforward invoice tokenization project quickly revealed far deeper structural issues in debt markets. This is the kind of stuff we like.

The framework we developed for that initial client engagement, which also has specific geographic institutional context not directly available elsewhere, served primarily as an education. It showed us what wouldn't work as much as what would and where the key challenges lie.

Our current work has evolved substantially beyond that original scope, addressing fundamental market failures that no simple tokenization scheme could solve.

## Series Structure and Scope

This series documents our journey from a client's invoice tokenization request to developing our own comprehensive solution for short-term B2B debt markets. It follows both our learning process and the systematic construction of infrastructure that addresses the fundamental problems we uncovered.

Due to the interdisciplinary nature of debt tokenization — spanning blockchain architecture, corporate finance, supply chain operations, and regulatory compliance and therefore crossing different, specialized domains and their communities - we believe there is value in sharing parts of the learning process.

Topics include:
- The initial tokenization framework and why it wasn't enough
- Legal and regulatory requirements across jurisdictions
- Information asymmetry and zero-knowledge architectures

and more.


The next post examines our starting point: the client project that revealed how tokenizing invoices, while technically straightforward, merely scratches the surface of what's actually needed to transform SME financing.

---
[^1]: See [RWA.xyz](rwa.xyz) for the evolution of tokenization markets.

[^2]: [FED note on private credit](https://www.federalreserve.gov/econres/notes/feds-notes/private-credit-characteristics-and-risks-20240223.html); [IMF blog post about private credit](https://www.imf.org/en/Blogs/Articles/2024/04/08/fast-growing-USD2-trillion-private-credit-market-warrants-closer-watch)

[^3]: Directive 2011/61/EU of the European Parliament and of the Council of 8 June 2011

[^4]: The project referenced is currently on hold client-side. All analysis and opinions expressed are those of 20squares alone.
