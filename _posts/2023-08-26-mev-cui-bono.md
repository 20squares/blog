---
layout: post
title: "Developing the MEV infrastructure: Cui bono?"
author: Fabrizio Genovese, Daniele Palombi, Philipp Zahn
categories: [MEV, economics, user experience, intents, PBS]
excerpt: A non technical, common-sense investigation of how an increasingly complex MEV infrastructure will look like from the end-user perspective.
usemathjax: true
thanks: We want to thank Aniket from Bicotomy, since the bulk of this post is elaborated over material surfaced in a chat with him.
---

MEV and MEV-related topics have been at the forefront of crypto research for years now.
As of now, the most important piece of research being actively worked on is probably PBS - Proposer-Builder Separation. Simply put, PBS will make the division between block proposers and block builders part of the Ethereum protocol.

In this post, we apply a set of selected, refined techniques called *common sense™* to try understanding how a simple operation like 'submitting a transaction' will look in the future, from the eyes of the common (non MEV-aware) user.

## A bit of history

To understand what is happening now, we first have to understand how we got here. The history of MEV starts more or less with [people becoming aware](https://arxiv.org/abs/1904.05234) of the fact that users' transactions weren't just being included in a block: A class of highly strategically competent actors, called *searchers*, was constantly observing the *mempool* - that is, the set of broadcasted transactions waiting to be picked up by miners - to figure out how to *extract* the *value* implicitly created by the changes these transactions would cause on-chain. The fact that strategically-aware actors can *observe* a transaction before it is included in the block means that they receive a *signal* on which they can act upon if they are fast and smart enough.

...So the community gets aware of the fact that MEV exists. This had two big implications:

> 1. The realization that you, the transaction provider, can pay for your transaction:
    - Explicitly, in the form of gas fees.
    - Implicitly, in the form actors extracting value from your transaction. This payment sometimes comes out of your pocket, e.g. when you get sandwiched, and sometimes does not.
2. The realization that gas prices and network congestion were heavily influenced by searchers: At the time, gas price was basically the only parameter searchers could tweak to ensure their transactions would end where they wanted in the block, which often resulted in soaring gas prices.

## Here come relayers

High gas fees, network often congested, users paying indirect fees on top of the ones they are already paying explicitly. To solve this, some people just suggested to 'outlaw MEV'. This naïve position holds no real substance when one realizes that MEV doesn't really go away: We can at best decide who gets to take it, or to waste it altogether. This is beautifully explained by Xinyuan Sun in his [This is MEV](https://www.youtube.com/watch?v=8qPpiMDz_hw) talk at Devcon VI: By 'wasting MEV' (for example by forcing a given transaction ordering), we are also wasting welfare-maximizing opportunities that would result in an *overall better* user experience. We will touch again on this in a bit.

In any case, the Flashbots collective provided a mitigating solution by making the infrastructure more expressive. They offered a way for transaction providers and searchers to submit their transactions directly to Flashbots, without going through the usual mempool. This would drastically reduce the possibility of being 'snipered' by MEV bots. On the other end of the foodchain, they onboarded some trusted miners, which would run a modified version of the usual Ethereum software. These miners would work as they always did, but they would also receive a block from the Flashbots relayer. Ultimately, the miner would greedily choose the block that paid more fees.

So this relayer-based solution offered a way  to 'discipline' MEV, allowing both transaction providers and searchers to avoid the mempool. Users would benefit from the increased privacy, whereas searchers would drastically reduce engaging in gas wars.

## And then PBS

The problem with all this is centralization: Suddenly, a lot of transactions go through Flashbots. Moreover, the only miners that could join this initiative had to be trusted ones, since by definition the miners involved would get to observe the Flashbots-provided block before publishing it. Moreover, Flashbots (and other relayers that came later) are incorporated in various jurisdictions and have to be compliant, introducing fears of censorship.

To reduce centralization, and thanks to what has been made possible by transitioning to Proof of State consensus, PBS (Proposer-Builder Separation) came to see the light. The main idea is to separate who proposes and who builds the block into distinct roles. A block builder would buy the right to build a block from the block proposer through an auction, and this agreement would be settled with a mechanism that forbids each party to scam the other. So the block proposer gets the payment, whereas the block builder gets to keep the tx fees and the MEV. This 'bidding for blocks' is already working through relayers, but solutions such as [ePBS](https://ethresear.ch/t/why-enshrine-proposer-builder-separation-a-viable-path-to-epbs/15710?u=barnabe) or [PEPC](https://efdn.notion.site/PEPC-FAQ-0787ba2f77e14efba771ff2d903d67e4) aim to directly extend the Ethereum protocol to make PBS part of the core infrastructure.

The idea of PBS enables to further diversify and differentiate the landscape. For instance, we could imagine partial block auctions, where many block builders get different pieces of the block. Another proposal, which is a conceptual specialization of this concept, revolves around considering the top of the block and the rest of the block as different resources.

## And then intents

In addition to all this, the upcoming [EIP-4337](https://eips.ethereum.org/EIPS/eip-4337) around account abstraction will allow to specify what people are now calling *intents*: The idea here is that instead of deploying a normal transaction, transaction providers deploy transactions that contain lists of constraints that need to be satisfied. Then specialized searchers will look for executions that satisfy these constraints, and will be able to provide the solution. As such, the user can just state what they want, without having to worry about how to do it. This would result, it is claimed, into better user experience overall.

## Common-sense considerations

Ok, so this is more or less where we stand. At the moment, the actors involved in the lifecycle of a transaction are:

- **Transaction providers** (users etc.), which create transactions.
- **Searchers**, that try to extract MEV from transactions.
- **Builders**, which assemble the blocks.
- **Proposers**/**Validators**, which put the blocks on-chain.

>There is a hard line to be drawn between transaction providers and all the other actors: There is only one party that pays: Transaction providers, which just want their transactions to be included. All other actors make money off the transaction providers' transactions.

Proposers and builders are paid to guarantee transaction inclusion. In the good old days of mining, this was pretty much evident as miners would be paid directly with gas fees. Now things are a bit more complicated, as proposers are paid indirectly by builders that in turn get transaction providers' transaction fees. Searchers may either get paid by the user willingly to perform some kind of service (such as for CowSwap), or unwillingly as in the case of exploitative sandwich bots.

In any case, the number of parties a user has to 'talk with' to get their transaction on-chain is growing (and with [PBS Guild](https://collective.flashbots.net/t/pbs-guild-proposal-v3-wip/2223) Relayers will probably get a piece of the cut as well), and more complicated infrastructure such as fractionalized/recursive block auctions will make this phenomenon even worse.

Simple *common sense™* tells us that the cost of getting something done grows proportionally to the number of intermediaries one has to deal with in the process, and it isn't hard to figure out why: This market is as free as it can get and in a free market no one works gratis, so all actors involved in a transaction lifecycle will want their cut.

To give you an example, consider [CowSwap](https://swap.cow.fi/#/faq/protocol). The idea of CowSwap is the one of a DEX where swaps are first ran through a network of dedicated searchers that **for a fee** will bundle up transactions in a way that is beneficial to the end user, e.g. by minimizing slippage. But the **for a fee** part is important: What is really happening here is that what the transaction providers paid implicitly before - in the form of slippage, being arbitraged upon etc. - now they pay explicitly. What changes is not so much the economic convenience for the end user, which still has to pay some third party in any case, but the overall transparency of the process.

In turn, CowSwap and other protocols that offer this kind of services will have to get their bundles into a block. Unless they do the block building themselves (and often they don't have enough orderflow to), they will have to rely on a third party block-builder, that will ask for its cut and will bring the end cost to the user even higher.

So, all in all, what PBS is solving isn't really much of a UX problem: Indeed, the UX is probably getting economically worse for the end user in many circumstances - especially for users moving little money, which are less likely to be pray of MEV bots. PBS was intended as a solution to a centralization problem, fragmenting and disciplining a monolithic infrastructure, at the proposer layer. 

But what happens to rest of the value chain? And how does the rest of the value chain affect proposers?

## Here comes centralization

In a [recent tweet](https://twitter.com/specialmech/status/1691178038640492544), Special Mechanism Group highlights how integrated builder-searchers are on the rise. An integrated builder-searcher is nothing more than a searcher that bids directly for blockspace.

This should not be conceptually surprising, and it is indeed a very old phenomenon: Depending on my own capabilities and the price setting by third parties, I can *verticalize* my operations. If sufficiently effective, I will now pay the previously outsourced goods at lower costs, taking out fees an intermediary could take. Over time, through learning, I might be able to further reduce my costs and increase my margin.

What is interesting though, there might be an additional rationale at work: Through integration I, as a searcher, might erect barriers of entries that make it harder for a new competitor to enter the search space. Such moves per se are not specific to PBS or crypto for that matter but are standard topics for (controversial) discussions in markets.

### Integrating proposers

Indeed, at 20[ ] we're very prone to consider builders and searchers as conceptualy isomorphic: A profitable searcher with sufficient capital will inevitably venture into block building to be able to increase margins. While the logic of integration for costs reasons does not readily apply to proposer integration - remember, a business intentionally designed to be relatively dumb - the logic of integration for reducing competition possibly does.

In other words, a searcher with sufficiently deep pockets can invest in staking with the goal of dynamically tipping the scales in his favor. An integrated searcher/builder still needs to buy blockspace from a proposer. Becoming a proposer as well, the searcher can intercept at least some of that money outflow and cut searcher competitors out. Now, we are speculating here - we are not aware of empirical evidence in this direction. Moreover, we have not built a formal model. All we want here is to raise attention for the possibility: 

> We bet 50cents and a six pack that in the next months/years we'll see the rise of **integrated searcher-builder-proposers**.

But if so, does PBS really prevent centralization? As things stand now we're a bit skeptical about that. Given how much technological advantage matters in this space, we would not expect a state of monopoly to hold for long (a better searcher may always enter the market and steal the crown). Yet, 

> We deem it likely to see the market stabilizing into a sort of 'succession of dynasties' ecosystem where a very small number of integrated players reign sovereing (old dynasty) for months/years until some more technological advanced player trumps the game (change of dynasty). 

Looking at things from this point of view, integrated **searcher-builder-proposers** really seem inevitable: in securing part of the proposer market a searcher can distort the fierce competition on state-of-the-art search. Maybe this strategy works only for a while but extending one's reign even for a while can be very lucrative.

### Orderflow monopoly

In addition to this, there's the problem of *orderflow monopoly*: If a transaction provider or a searcher wants to ensure fast inclusion, they will want to send their orderflow to builders that win blocks often. Inevitably, the better one is at winning, the more orderflow they will intercept.

In the context of [Order Flow Auctions](https://writings.flashbots.net/order-flow-auctions-and-centralisation), where searchers pay transaction providers for their transactions, this will probably become even more accentuated: A good searcher will be able to extract more MEV, and thus will pay the order flow provider more, ensuring even better orderflow. This has again been [highlighted by SMG](https://www.mechanism.org/spec/02). 


## Are there any mitigating solutions?

For sure, things that may help with centralization are:

- Breaking up the monolithic block structure as a whole-sale good could reduce incentives and opportunity to distort competition.
- Fractionalized block auctions. This is something we've been working on in terms of building a generalized simulation stack for the job, see e.g. [our talk at EthCC](https://www.youtube.com/watch?v=uZfmvJfFmqM).
- Giving searcher/builders a way to talk to each other. Often builders know beforehand if they are going to win the block auction or not. When they aren't, it would be useful for them to ask the winning builder if they have some free blockspace to squeeze their transactions in. A matchmaking/contracting mechanism around this would ensure that less fortunate builders do not have to aggressively defend their orderflow by means of block subsidization and the like.
- Proposals such as [MEV Burn](https://ethresear.ch/t/mev-burn-a-simple-design/15590) will help smoothing out centralization issues during large MEV spikes.

> In any case, these mitigating solutions will probably help fighting centralization, but in no way they will make the user experience economically better fee-wise.

## The myth of welfare-maximizing MEV

As we pointed out in [Here come relayers](#here-come-relayers), there are forms of MEV that aren't necessarily bad for transaction providers: Given a set of transactions, for sure they can be ordered or more generally included in a block in a way that maximally benefits some actor, for instance a searcher. But there are also orderings that maximize some utility function that is taken to represent the overall welfare of the system. These orderings represent the 'best possible allocation of MEV'. This has been discussed at length, and has been embodied in various ideas of 'returning MEV back to the transaction provider'.

Welfare-maximizing orderings may be proved by means of commitments or other cryptographic gadgets. We are only interested in the economic point of view here, so won't dive into details. Let's just say that with enough wits, we may force searchers to prove that the bundles they provided do not include any toxic MEV (such as sandwiches).
Still, as we already said, actors involved in the MEV foodchain do not work for free. So,

- Either there is a particular way to include transactions that produce MEV dependent on the transaction *set* (the MEV of the bundle is bigger than the sum of the MEV of its parts), which can then be used in part to pay searchers/builders and in part can be returned to the transaction provider, or
- There is not such thing, in which case either searchers/builders will get MEV out of transaction providers' pockets, or they will simply refuse to include such transactions in case the fees paid are not high enough.

As we stressed already, the 'real' fee a transaction provider has to pay is:

$$\text{Gas fee} + \text{MEV}$$

Where the first factor is always paid directly by the transaction provider, while the second may not be. 

As of now we have many different, specialized actors active in the transaction lifecycle, and all these actors will need to get some revenue. So, the sum must be high enough to be profitable for searchers/builders. In the context of a dynamic market, having a low second factor could mean that the first factor needs to be set higher to make the transaction competitive enough so that it is included. 

To make an example, let's suppose that we have $t_0, t_1, \dots, t_n$ transactions such that:
- Only $n-1$ transactions can be included in the block for space reasons;
- all transactions have similar fees;
- $t_0, \dots, t_{n-1}$ are high in MEV, whereas $t_n$ is not.

In this situation, and everything staying equal, MEV searchers should decide to include $t_0, \dots, t_{n-1}$, leaving out $t_n$. Hence, to stay competitive, $t_n$ will have to be provided with a higher gas fee.

>We call this concept 'MEV pressure', and it amounts to 'accounting for other providers' capacity of providing MEV to stay competitive'.

Similar to the case of CowSwap, MEV pressure just amounts to making an implict cost explicit, and shows how even 'MEV indifferent' transactions have to account for MEV in the fight to be included. We do not know if MEV pressure has been already observed in the wild or not, but at least conjecturing its existence seems plausible.

MEV pressure aside, from a more general point of view,

> welfare-maximizing MEV seems to be at odds with the current fee market structure.

This is because, as they are defined now, fees serve a one-dimensional purpose: An actor pays a fee to get a better service. The higher the fee paid, the higher the actor's priority with respect to being included. Yet, if we are maximizing for welfare, it may very well be that a given transaction, even if being provided with the highest fee, would serve a much better purpose if it wasn't included first. In this case we face a dilemma: An actor paid a lot to be included first, but the overall welfare is maximized (maybe with a little loss for the actor in question) if the transaction is included later. What do we do? Do we honor the idea that 'the more you pay, the better you get treated' or do we maximize welfare altogether?

We do not have an answer for this, and whatever decision one takes has a clear political and ideological connotation. As others have, we are merely pointing out that as things stand now welfare-maximization may be at odds with how market fees are defined.

## Intents: Better UX but for a price

Finally, let us spend some words on intents. The idea of intents is that we give the end user a better experience by abstracting the nitty-gritty details of how a given operation has to be carried out. Again, since this operation will be offsourced to a third party actor, it won't be for free:

> Given a set of constraints defining an intent, the third party will always try to do as little as possible to 'honor' the intent, while maximizing his own profit.

We formalized this mathematically in our previous post, [Lagrangian mechanics of intent solving I]({% post_url 2023-07-26-lagrangian-intent-search-i %}). Again, this should not be surprising. For example, suppose that we give \\$10K to someone - let's call him 'John' - with the task of buying us a car. If John finds a retailer that will sell us the car for \\$8K, he is incentivated to say that he found us a car for exactly \\$10K, and to pocket the \\$2K difference.

The natural way to solve this problem is to task multiple intermediaries, thus making the market competitive. The best intermediary providing the best price will be the winning one - hoping they do not collude. But then we run again into a problem of centralization: We may very well see, pretty quickly, that one intermediary works better than anyone else, getting control of the biggest share of the market.

What this means is that user convenience and decentralization are easily at odds, and maximizing both requires a non-trivial mechanism.

## Conclusion

In this post we explored several hot research topics in MEV-land in intuitive terms, and showed how often decentralization is paid in terms of bigger costs for the transaction providers. The reason for this, at its core, seems to be the following vicious circle:
- 'Simple' systems can be gamed by unscrupulous third parties, creating a bad experience for users.
- To mitigate this, we need to add additional actors to the mix.
- Now we have multiple actors working on the protocol. They do not work for free, which reflects as a bigger cost on the end user.
- To ensure that the newly added actors do not collude or obtain a state of monopoly, we need to make the infrastructure more bureaucratic and complicated, again at the end user cost.

Ok, so this is it with regard to the bad news. As for the good news, at the moment we don't have any. We can only say that we're thinking about these problems very hard, and are always open to collaborate with whoever finds these ramblings interesting.
