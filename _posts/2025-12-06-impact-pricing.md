---
layout: post
title: "The ROI of your action"
excerpt: "In which we briefly present our framework that applies impact pricing like capabilities from finance to industry domains"
author: Philipp Zahn
categories:
date: 2025-12-06
usemathjax: true
thanks: "Thanks to Fabrizio and the rest of my team at 20squares for comments"
---

At 20squares we have a quantitative economic consulting division that helps clients on a wide range of topics: market design, dynamic simulations, fee optimization etc.

We sometimes get asked, how do you work across such different domains? After all some of these problems seem totally disconnected.

There are three answers:

1. We have a team with diverse backgrounds that cover a lot of ground, from pure Math, Physics, Economics to practical skills like data science, programming, dynamic systems modelling.

2. We work with sophisticated clients who know their domain deeply; which makes it easy for us to interface.

These are true and important but boring answers. Here is the interesting one:

3. We have one framework to attack many of these apparently independent problems in a similar and systematic way.

If you want a slogan: We build a quantitative ROI of your actions in (more or less) structured market environments.

In this post I want to briefly talk about this framework.

# 3 Problems

Consider three cases, versions of which we have worked on:

1. You are a company with a sophisticated revenue management system that generates automatic pricing. You are active in many local markets, and typically have one, sometimes two competitors (themselves large companies).

2. You are a trading firm and you need to sell a position on your books; by selling you will most likely affect the price at which you can sell. Depending on the market structure and how you sell over time, this means losing (a lot of) money.

3. You are a gaming company offering promotions to players. How should you choose these rewards?

None of these problems are original. Meaning, we are not the first ones to work on them. The extreme is case 2; organizations trading in financial markets have every incentive to get this right.

And, not surprisingly, there are specialized solution providers for this. First order, specialized actors will be more effective than us who come from the outside.

So, how do we compete? Well, it would be outright stupid to try to improve how a big trading firm places equities or any other standard financial instruments in the market. But once in a while, an opening happens, a new structure forms. Think about getting your transaction into a block on Ethereum. Not exactly the same but close enough?

And this is key: 1 and 3 are versions of 2. So is the example of getting your transaction into a block.

What unites these problems? In each case, your action changes the environment in which you operate, and that change feeds back into your outcome. The trading firm's sell orders move the market price. The company's pricing decisions trigger competitor responses. The gaming company's promotions shift player expectations and behaviour. Structurally, these are all instances of the same problem: quantifying how your intervention propagates through a reactive system and returns to affect you. Finance calls this 'market impact.' We generalize it.

Think about this: very fine-tuned adaptation aka specialization works very well and most effectively in a stable environment. But once your environment becomes less stable or maybe even highly uncertain, fast adaptability becomes relevant.

This is where we have an advantage. And, we would wager that world is moving in this direction.

# 4 Trends

We have observed four trends that shape how actions affect outcomes (trade on market prices; promotion on user retention) or more generally of action x on outcome y:

- Everything is interconnected
- Everything is multiplayer
- Everything is algorithmic
- Everything is AI

## Everything is interconnected

We have been active in the crypto space for years. The trend is now obvious: crypto (or parts of it) is becoming mainstream. But what interests us here is a pattern we first noticed during the DeFi summer of 2020: an expanding causal cone. As interconnection increases, more and more potential pathways of influence emerge through which interventions or decisions can shape the system. This was evident in the Ethereum's transaction supply chain (or what people call MEV in the broader sense): How do transactions travel from users to their final position in a block, and who can intervene along the way?

The same phenomenon is playing out with AI right now. What started as a small nucleus is now rapidly expanding, with new pathways of influence appearing every day.[^2]

In these phases, being fast, adaptable, and able to bridge expertise across domains is decisive. And that is where we have an edge - more on this below.

As a sidenote: When a system's causal cone is still small, there is an opportunity not just to adapt to it but to help shape it. We try to act on this where we can. Through NeverLocal, a joint venture we founded with partners from Oxford, we are working on the transition of blockchains into the post-quantum world; getting involved early, while the structure is still forming.[^3]

I focused on technical openings, but the same dynamics applies to established companies on pure business grounds. There is a VC saying "Every Company Will Be a Fintech Company"[^1]. We see this happening through AI right now; it might well happen through prediction markets and many other things.

We also see this in B2B settings, where data collection is catching up fast, and new pricing models (subscription based on usage intensity) are now feasible. (And if you happen to work on this, we would like to have a word with you!).

The bottom line: Optimizing key decisions and understanding their impact is less static than it was 10 or 20 years ago. Our world has become stranger and less predictable. This brings danger but also opportunity.

## Everything is multiplayer

For a long time, airline revenue management systems have been the most sophisticated in any industry.[^4] What may sound surprising: These systems often assume a single player aka the airline in question is making decisions alone - no competitor in sight. This might be true for some routes but for many it is simply false.

The same is true in  other industries that use advanced tech.[^6] Now, there are understandable reasons for this. One is very simply absence of data. When airlines first built their systems data was scarce. And data about other companies was basically non-existant.[^5]

Another factor  applies to businesses built on top of the internet. If you are a (very) large platform, chances are that you are more or less a monopolist. So, you can safely ignore competition in your models.

But there is an interesting middle ground: companies that are neither big tech nor tiny startups. Which, buy the way, has more to do with the competitive landscape than sheer size. You can be big and still be very limited in your options (see the German automotive industry these days).

Now combine this with what I noted earlier: the world is becoming more interconnected. Remember the [Ever Given blocking the Suez canal](https://en.wikipedia.org/wiki/2021_Suez_Canal_obstruction)? In such a world, there are tremendous benefits to being both, fast to adapt _and_ aware of competitors when choosing your actions.

## Everything is algorithmic

Airline prices are computed according to algorithmic formulas. The price of a specific seat, in a specific class, on a specific route, on a specific date gets updated multiple times a day, every day until departure. Beyond that, we have dynamic pricing (as in Uber's case) reacting to demand and supply in real time and continuous market places like financial market places (or the old fashioned markets following opening hours schedules).

In the past, humans set prices (sometimes supported by sophisticated reasoning). In the examples above, prices are encoded as algorithms which respond to input (say demand shifts due to rain in the case of ride-hailing). Humans could not do this pricing themselves. The extreme case is finance, where for certain types of trading speed is almost everything.

It is not only the pricing or other internal policies that have become algorithmic. So have the market places themselves. In some cases, the market place _is_  the product a company offers; in others it is the environment where companies interact. A striking example is blockchains where the entire machinery runs on algorithmic protocols.

The trend is clear: decisions are increasingly made or mediated by algorithms. If you are thinking about strategic competition, you should think in terms of your algorithms competing against other players' algorithms.

## Everything is AI

This should be obvious, so I will be brief. Regardless of where you stand on the spectrum from "OMG we have AGI in one year" to "LLMs only produce slop", it is  clear that AI plays an ever larger role in how decisions get made.

On one hand, AI is just another expansion factor: the causal cone of how the environment will react to your actions widens and gets deeper. Consider SEO, search engine optimization. This was a well-understood game. But now with LLMs summarizing content, clicking behavior is changing. That affects established sales funnel models, which affects revenue, which affects entire business models.

On the other hand, wherever you stand on AI's capabilities and trajectory, your own interactions with your environment will increasingly be with AI. If you are negotiating prices as a supplier, chances are you will be interacting with an agent at some point.


# Our approach

All four trends make our world more interconnected, more automatic, and more uncertain. Understanding how your actions influence outcomes quantitatively, the "ROI of your action", becomes essential. In the age of AI, this is ever more pressing: if you can define an impact measure, chances are you can leverage AI to improve it.

So, let me briefly talk about what we do.

## The core

The basis is simple: We need to understand how your action x influences your outcome y. Where y is any of the general measures of business success: profit, market share, customer satisfaction, slippage, and so on.

At the core of what we use is the [open games engine](https://github.com/CyberCat-Institute/open-game-engine). We have used it in many settings and written about it at lengths.[^7]  So I will keep this short.

When we started out in crypto, we mostly used the engine for classical game theoretic questions: understanding consensus mechanisms and analyzing potential attack vectors, evaluating new protocols or incentive mechanisms.[^8]

One technical element that the engine provides is the automatic construction of what we call, in our theoretical work, the "unilateral context". This represents the actions a player can take at given point in time and how those actions affect the environment, most often restricted to his own payoff, which most often means his profit, or ROI on your action: an approximate causal model of your influence in the world.

The key thing is that the engine assembles this unilateral context automatically from the model. Because models are built up by composition (which we talk about at length elsewhere), the engine handles the book-keeping by threading game and multiplayer logic together (including actions, information, uncertainty, etc.).

So far so good. But this tooling seems useful only for problems that are game-theory shaped. Such problems exist and have become more common (e.g. in blockchain land), but are ultimately limited in scope.

Here is a something we (and others) recognized after we had done our research and first implementation of the engine: The underlying theory and the implementation are not limited to classical game theoretic models. If you are interested in algorithmic competition, well, then we represent your agent as an algorithm. It is code after all. But not only that. The agent can also be a learning agent which makes it straightforward to study strategic interaction among learning algorithms.

The result: the engine lets us build complex multi-agent models quickly, and extract the action ROI for specific players.

A natural question is: how does this differ from agent-based modelling? The difference is flexibility across the spectrum from simulation to theory. We can run plain simulations, but we can also do pure formal game-theoretic analysis. And, crucially, hybrids of both. For example, we might use a game-theoretic core for optimal pricing decisions, but feed it with demand estimates derived from data or behavioural parameters calibrated through simulation. Standard agent-based models simulate; our engine can also solve.

## The data

All of this is well and good. The fact that we can include algorithmic and learning agents widens the scope of applicability significantly. But it is still purely theoretical. If you are a major blockchain planning to replace your current proof-of-work consensus mechanism with a novel proof-of-stake mechanism, this really is a theoretical exercise.[^9] There is not much data on which you can base your assessment.

In most other scenarios though you actually have data; sometimes even loads of data. Think airlines or e-commerce. This is where we have seen the most dramatic improvements over the past two years.

It is now very easy to integrate data flows into the modelling engine; it is software after all. But more importantly, AI has made the modelling process itself, deciding which data to include and how, so much easier that we can now tackle problems that were totally, like really not at all possible, just 2 years ago.

We now have a robust process for ingesting raw data and incorporating it into our game-theoretic models.

A sidenote: AI also helps tremendously with solving models. This is another area where lots of progress has happened but not necessarily on everyone's radar.

## The process

One feature of the engine is central to how we approach problems: Model==Code. I have written about this [before](https://www.philipp-zahn.com/research/codeastheory/). The key point is simple: Because model equals code, modelling becomes software engineering. This enables iterative improvements of the overall model. And because the model consists of components, we can iterate, improve, and refine on individual parts as well.

This extends the engine's prototyping capabilities to the full pipeline, including data and estimations.

This design also enables systematic handling of approximation errors at every stage. When you estimate demand, your data may be incomplete, biased, full of measurement error. That estimate becomes input to later computations. You need to track how errors propagate.

Taken together, we get a systematic procedure for building the ROI of your actions. 

# Domain arbitrage

The strength of our approach lies in turning unstructured problems into problems that people familiar with impact pricing in finance will recognize.

Our experience is that the wider the initial delta, the more value we can  create. Of course, we cannot turn every situation into a useful form. 

But in our experience it does work surprisingly often. And it is important to keep in mind a lesson that people in finance are well accustomed to: even a small edge, say a tiny probabilistic advantage, in the extreme just above 50% (so pure randomness) can lead to extraordinary returns.

If you face a decision problem where your actions affect your environment, whether that's competitors reacting to your prices, markets moving against your trades, or users responding to your incentives, there's a good chance our framework applies. The structural pattern is the same; only the domain differs. Get in touch, and we can find out.


[^1]: See https://a16z.com/every-company-will-be-a-fintech-company/
[^2]: Of course times of expansion are followed by periods of consolidation. Some pathways that have already been taken strengthen, while others are abandoned.
[^3]: My co-founder, Fabrizio is leading this effort. He has been vocal about the need for preparing since, like, yesterday, [early on](https://x.com/fabgenovese/status/1410564377489641473).
[^4]: Besides finance, other industries relying on advanced tech are hotels and hospitality, online travel platforms, ride-hailing and mobility platforms, e-commerce.
[^5]: We have been involved with an airline recently on a [project](https://cybercat.institute/2025/05/16/game-theory-rm/) of including strategic opponents in their systems. This airline prouds itself of being - even within their industry - at the forefront. Yet, even for them getting systematic data on their competitors is hard.
[^6]: It is even true to some degree of financial markets where there often is no explicit modelling of "the" competitors (which in contrast to the airline industry for instance are often not knwown in advance). Instead market forces are assumed and modelled that will react to actions.
[^7]: E.g. [here]( https://cybercat.institute/2022/06/24/a-software-engine-for-game-theoretic-modelling-part-2/), [here](https://blog.20squares.xyz/open-games-repost/), and [here](https://cybercat.institute/2024/07/15/usefulness-models/) on its role in modelling, and [here](https://cybercat.institute/2024/04/22/open-games-bootcamp-i/) for a more technical, first-principle consideration. See also https://cybercat.institute/blog/ for more general information.

[^8]: For some applications, which were done in the public domain, see our [blog](https://blog.20squares.xyz/).
[^9]: By all the complaints in the last years about Ethereum, it is easy to forget what a feat the [Merge](https://en.wikipedia.org/wiki/Ethereum#Transition_to_proof-of-stake) actually was. Changing the core of a very valuable system (even at that time) while being live and without missing a beat, is quite something.
