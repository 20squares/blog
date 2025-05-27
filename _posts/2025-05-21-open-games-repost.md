---
layout: post
title:  "A Software Engine for Game Theoretic Modelling"
author: Philipp Zahn
categories: Open Games
excerpt: A repost of our original introduction of the Open Games Engine
usemathjax: true
date: 2025-05-20
asset_path: /assetsPosts/2025-05-21-open-games-repost
---


## Introduction

In this post, we introduce a software engine for game theoretic modelling. Its development is supported through a grant by the Ethereum Foundation.  

This software toolbox has two main functionalities: (i) users can represent strategic interactions by modelling games and (ii) they can analyze these games, for instance by checking whether a given strategy is in equilibrium. 

A distinguishing feature of this toolbox is its _compositionality_: We aim at building models in a modular, reusable fashion. This enables the user to rapidly prototype and iterate through a range of models.

While the engine can be used for various types of strategic interactions, its most natural habitat is where computations and strategic interactions blend: Applications on Ethereum are an ideal fit.

We will first provide some background on the theory. This is can be helpful as a context so that users can better understand the syntax and the principles behind the software. Next, we describe the software system and how it can be used. We end on some future use cases that we envision (and are partly already working on).

We will avoid many details and focus on how to use the system. Therefore, we will illustrate its usage with an example: We represent and analyze a bespoke auction format. This is one of the applications we envision for our system.  Many smart contracts are riffs on existing allocation procedures. Even small changes in an existing mechanism, which may be well understood, can have significant effects on incentives. 


## Theory Background 

We give some brief background on the theory here. For some readers this might be useful to better make sense of the software. But by all means, skip it if you directly want to jump to the code.

Underlying the software engine is the theory of _open games_ (the most relevant articles are: [Compositional Game Theory](https://arxiv.org/abs/1603.04641) and [Bayesian Open Games](https://arxiv.org/abs/1910.03656); see also Jules Hedges' [webpage](https://julesh.com/2017/11/09/compositional-game-theory-reading-list/) which contains further resources).  Its key innovation is the decomposition of strategic interactions into atomic components. These components can be assembled through a fixed set of operations while guaranteeing that the result is well-behaved -- i.e. forms a proper _open game_ again.

The theory of open games is developed in a particular mathematical structure from category theory which allows representations in terms of _string diagrams_. These are two-dimensional diagrammatic representations of interactions which look like this: 

![Basic Game](/assetsPosts/2025-05-21-open-games-repost/GameSimple.png)

Essentially, all elements in a strategic interaction are translated into computations or processes. These computations are two-way information transformers. They take information from the left (X) and from the right (R) as inputs and transform them into outputs - also in both directions (Y and S). 

At a high level, the modelling task is to plug these components into each other such that the assembled object represents the intended interaction. You can think of this modelling as "plumbing together" the information flow of an interaction.  Here is a simple example of a simultaneous move game with two players -- essentially a standard bimatrix game like the Prisoner's Dilemma.

![Bimatrix](/assetsPosts/2025-05-21-open-games-repost/Bimatrix.png)

Here is an example of a sequential game with two players. That is, one player moves first, the second player observes the first player's move and then makes a decision.

![Sequential](/assetsPosts/2025-05-21-open-games-repost/Sequential.png)

And lastly, here is an example of an auction where the two bidders have private information about their evaluation for the good.

![Auction](/assetsPosts/2025-05-21-open-games-repost/Auction.png)

We will not dwell much on the technical details behind these graphical representations. What is important though (and what you should take away from the pictures at this stage) is that the graphical language operates in two dimensions. In the bimatrix case players 1 and 2 are put side-by-side as they move simultaneously. They are still connected though as their utility is affected not only by their own action but also by the action of the other player.

Obviously, there is still significant information missing such as what exactly are the strategies the players can choose? What are the payoffs etc? 

We will come to that. 

So far it is important to note there is a way of stitching together the different components which mainly works along two time dimensions: simultaneous and sequential composition.


## From Theory to Programming

At the core of turning the theory into actual programs is the representation of an open game unit. That plus composition operations allows users to create a large space of models. 

Our system is implemented in Haskell. However, we provide a small DSL for representing strategic interactions in a (hopefully) user-friendly way. This should enable users without knowledge of Haskell to represent games. 

Some knowledge of Haskell is needed to fill in details though: such as defining utility functions. We tried to limit the amount of Haskell needed; it is mostly focused on defining functions which is _relatively_ straightforward. Over time, we aim for reducing the amounts of Haskell needed. So, expect changes to happen as we keep hacking! (This holds more generally: The system is in an experimental state and is continuously extended.) 

The graphical representation is useful as one gets a quick perspective on what the information actually is. Moreover, turning towards our actual goal, namely program these interactions, it is important to note one challenge that we face (and which will pervade throughout the programming): The graphical syntax is two-dimensional but like most programming languages, our code must be one-dimensional. 

Hence, we need a way to flatten the two dimensions into one. We achieve this by cutting the two dimensions into parts, sequentialize these components, and connect them through variables. Bear this in mind; hopefully this makes it easier to grasp what is going on.

The syntax for programming has two parts, an _outside perspective_ and an _inside perspective_. Let us begin with the outside perspective. 

        _NameOfGame_ _var1_ _var2_ ... _varN_ = [opengame|
            
            inputs    : _InputGame_ ;                    -- This corresponds to X in the diagram
            feedback  : _FeedbackGame_ ;                 -- This corresponds to S in the diagram
            :-------------------------:
            
            INTERNALS OF THE GAME
            
            :-------------------------:
            output    : _OutputToOutside_ ;              -- This corresponds to Y in the diagram
            returns   : _ResultsReceivedFromOutside_ ;   -- This corresponds to R in the diagram
            
        |] 

The above expression is a declaration of an open game. You can think of it as a large (possibly constant) function. That is, on the left hand side of the equation you provide the name of the game `_NameOfGame_` as well as possible arguments that the game depends on `_var1_ ,...`. Think of the arguments as exogenous parameters on which the game depends such as utility functions, cost functions, discount factors, name of players etc. 

Regarding the right hand side of the equation, the `[opengame\| ... \|]` is the syntax that contains the relevant information to define an open game. The internals are seperated from the externals through two separating lines `:---:`. 

For now, we focus on the external parts. Recall the diagram above. The outside perspective corresponds to having the box with 4 wires. Hence, we need to provide inputs/outputs. In many cases this will boil down to assigning variable names to make clear on which information a game does depend on.

Let us now turn to the internal structure. It has the following shape:


        :-------------------------:

        inputs    : x ;                                                  --\
        feedback  : f ;                                                     \
        operation : dependentDecision _playerName_ _actionSpace_ ;           ==> LineBlock 1 
        outputs   : y ;                                                     / 
        returns   : payoffFunction x y (...) ;                           --/

        inputs    : a ;                                                  --\
        ...                                                                 \
        ...                                                                  ==> LineBlock 2
        ...                                                                 /
        ...                                                              --/
        
        ...
       
        :-------------------------:

The internals of an open game consists of one or more _LineBlocks_. Each LineBlock consists of five fields. 
It is not accidental that the internal structure closely resembles the outer structure. There are also four input/output fields. 

Recall that our goal is to model each component as a possible standalone open game which can be connected.
The main difference between the outer and inner layer is that each LineBlock requires an _operation field_. This is where information is actually transformed or generated. We will see several canonical operations that one can use. This includes, as depicted in the box above, a decision operator which -- given some possible prior observation, an action space (i.e. a list of possible actions to take), and information that is returned (his payoff) -- models a single agent who chooses an action. 

What action? For now, you can think about the agent maximizing his expected payoffs. In principle, we can also consider other decision criteria. But for simplicity, we will stick to the maximization for now.

It is crucial to realize that there is a "gap" between the decision operation and the return field. When we speak of maximization of payoffs, the objective function is typically a payoff function. Yet, you may wonder: In a strategic situation the decisions of others matter. Otherwise, what is the whole point, right? 

But as indicated above with `(...)` in the returns field, the payoff function can rely on other inputs from outside that single LineBlock, e.g. another player making a move.

It is your task as a modeller to make this dependency explicit. The compiler in the back then takes care of threading the needed information together. This also gives you a first rule of thumb how to approach modelling in our language. Whenever there needs to be an explicit modelling of decisions, payoffs etc., you will typically model those parts in terms of the internals of a game. 

Let us consider a concrete example of how this language works in action. After that we will turn to the question: what can you actually do with it?


## Auction Example

In the DeFi space but also in the Ethereum space, projects often come up with their bespoke version of some economic allocation mechanism. While there is a rich literature in mechanism design and auction theory about theoretically well-behaved allocation procedures, whenever one starts augmenting or altering an existing mechanism, its theoretical properties may be sensitive to such changes. 

Reasons for such changes abound: It may be that a particular action space is defined that is discrete. As always when we need to implement programs, complexity of some mechanism may require some simplifications or approximations. Or, as in the case we discuss next, there might be other concerns with respect to the allocation procedure that are not covered by mechanism design results. 

Consider the following allocation problem: Alice, Bob, and Carol want to buy a token. There are two tokens available. Now, instead of maximizing revenue alone, the organizer of that mechanism also wants to hand out one of the tokens by lottery. This example is inspired by the mechanism discussed in this [paper](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3049504). Some buyers may not be able to afford high prices. The lottery is meant as a (partial) counterpoint. 

This is implemented in the following way: All buyers bid simultaneously. The bids are randomly organized in a sequence. The highest bidder will receive one token and pay the second highest price. If one of the bidders who lost the auction is coming up early in that sequence he may receive the token at the reserve prices and thereby typically at a lower price.

Let us first represent the situation. 

Note, in order not get overboard in this post, we will leave out some of the implementation details. Please consult the codebase for details. The code for this example can be found here: [^auctionRepoPointer]. 

Also note, we have picked pretty arbitrary values. The equilibrium results are obviously sensitive to this choice. Lastly, this example is intentionally simple. We just use it only as an illustration. 


#### Representation

We split the model into three parts: Nature determines the types, bidding by players, and lastly the payment stage where the allocation is determined.

We begin at the top. We have a stage which represents "Nature" in the standard game-theoretic sense: `natureDrawsTypeStage` expects on external parameter `name`, the name of a concrete player. 

Internally, the `nature` operator takes a distribution as an input and draws an element from it.  Here, we assume a uniform distribution on a list of values. 

This stage then feeds a tuple of `(name,value)` to the outside world.

      natureDrawsTypeStage name = [opengame|

          inputs    :   ;
          feedback  :   ;

          :-----:
          inputs    :   ;
          feedback  :   ;
          operation : nature (uniformDist values) ;
          outputs   : value ;
          returns   :  ;
          :-----:

          outputs   :  (name,value) ;
          returns   :    ;
        |]


Next, we model the bidding stage, `biddingStage`. This stage requires a name for a bidder as an exogenous parameter. Internally, it expects a pair of name and value. Then the players bid after observing their private type. For simplicity, we restrict the bid to a few values (0,20,40,60) but that can of course be changed. The module outputs the decision of the player and expects a list of payments back.


      biddingStage name = [opengame|

          inputs    :  nameValuePair  ;
          feedback  :   ;

          :---------------------------:
          inputs    :  nameValuePair  ;
          feedback  :   ;
          operation :  dependentDecision name (const [0,20..60]) ;
          outputs   :  dec ;
          returns   :  setPayoff nameValuePair payments  ;
          :---------------------------:

          outputs   :  dec ;
          returns   :  payments  ;
        |]


Next, the payment stage. This represents the actual economic mechanism. `transformPayments` requires some outside parameters: the pricing rule (i.e. first price, second price etc.),`kPrice`, number of tokens to be allocated by price, `kSlots`, number of slots being allocated by lottery, `noLotteries`, and, lastly, a `paymentFunction` which determines who receives a token at which price. 

Internally, this stage expects a list of bids from the outside world. It then randomly reshuffles this list (first LineBlock) and finally, determines the allocation given the bids (second LineBlock). It outputs a list of payment information.

      
    transformPayments kPrice kSlots noLotteries paymentFunction = [opengame|

      inputs    : bids ;
      feedback  :      ;

      :-----------------:
      inputs    : bids ;
      feedback  :      ;
      operation : liftStochasticForward shuffleBids ;
      outputs   : shuffledBids ;
      returns   :      ;

      inputs    : shuffledBids ;
      feedback  :      ;
      operation : forwardFunction (auctionPayment paymentFunction kPrice kSlots noLotteries) ;
      outputs   : payments ;
      returns   :      ;
      :-----------------:

      outputs   : payments ;
      returns   :      ;
    |]

Finally, equipped with these three pieces, we can stitch the auction together.  As before with the payment rule, `bidding` expects `kPrice`, `kSlots`, `noLotteries`, and `paymentFunction`. We have specified this game for three players but obviously, it could be extended.

The first three lines inside the game, expect the game that we defined before, `natureDrawsTypeStage` and determines a type for Alice, Bob, and Carol. Next up is the bidding stage for each player. Lastly, we end with the payment stage. Note how we use variables to connect between different stages (e.g. `aliceValue`). 


      bidding kPrice kSlots noLotteries paymentFunction = [opengame| 

        inputs    :      ;
        feedback  :      ;

        :-----------------:
        inputs    :      ;
        feedback  :      ;
        operation : natureDrawsTypeStage "Alice" ;
        outputs   :  aliceValue ;
        returns   :      ;

        inputs    :      ;
        feedback  :      ;
        operation : natureDrawsTypeStage "Bob" ;
        outputs   :  bobValue ;
        returns   :      ;

        inputs    :      ;
        feedback  :      ;
        operation : natureDrawsTypeStage "Carol" ;
        outputs   :  carolValue ;
        returns   :      ;

        inputs    :  aliceValue    ;
        feedback  :      ;
        operation :  biddingStage "Alice" ;
        outputs   :  aliceDec ;
        returns   :  payments  ;

        inputs    :  bobValue    ;
        feedback  :      ;
        operation :  biddingStage "Bob" ;
        outputs   :  bobDec ;
        returns   :  payments  ;

        inputs    :  carolValue    ;
        feedback  :      ;
        operation :  biddingStage "Carol" ;
        outputs   :  carolDec ;
        returns   :  payments  ;

        inputs    :  [("Alice",aliceDec),("Bob",bobDec),("Carol",carolDec)]  ;
        feedback  :      ;
        operation :  transformPayments kPrice kSlots noLotteries paymentFunction ;
        outputs   :  payments ;
        returns   :      ;
        :-----------------:

        outputs   :      ;
        returns   :      ;
    |]


The representation above, of course, is not the _only_ way to model the situation at hand. This representation is also overly verbose; we could put everything into one large game and get quicker to where we want to be. Here, we instead chose the more scenic route. It illustrates how the system supports the modular setup of models. 

Ok, now that we have the game represented, what can we actually do with it?


#### Analysis

Our main focus, and what the system supports so far mostly, is the equilibrium checking of strategies. That is, you can query a given game with a strategy and the system will tell you whether that strategy is an equilibrium. If it is not, it will output a list of debug information. In particular, it tells you which player has a profitable deviation and what that deviation is. 

Let us add more details. First, we assume that the players' types are drawn from a set with three values (20,30,60). This is obviously arbitrary and can be changed. As standard in auction theory, we assume that the payoffs of players is: 

       payoff_i = prob_winning_good * value_i - payment_i

We assume that the reserve price of the auctioneer is 1 and we assume that the pricing rule for paying bidders is the 2nd highest price. All of these values are of course arbitrary and can be changed as one pleases. 

How shall we query the game above? As a first pass, you may wonder whether "truthful" bidding is an equilibrium strategy of that game. That is, bidders just bid their exact valuation which they privately observe. For some well-known auction formats with a 2nd price rule this is indeed an equilibrium strategy.

The relevant command for this is `evaluate` which takes a game and a strategy (and a so called context -- you can ignore this for now). It outputs raw information about whether the supplied strategy profile is an equilibrium or not. For the game above this looks like this:

      equilibriumGame kPrice kSlots noLotteries paymentFunction strat 
        = evaluate (bidding kPrice kSlots noLotteries paymentFunction) strat void


Note, that we give the evaluation itself a name, _equilibriumGame_, for reasons that will become clear in a minute. Also note, this equilibrium query expects the same parameters as the game itself (_kPrice_ the pricing rule, i.e. 1st price, 2nd price, no of slots allocated through prices, through lottery, payment rule). 

In order to make this easier to use, our system provides some convenience functionality. One of the functions that users can employ is `generateIsEq`. It provides diagnostic for the user. So, supplying the relevant information yields for instance: 

     generateIsEq $ equilibriumGame 2 1 1 lotteryPayment truthfulStrat
     
In words, this checks the equilibrium for a 2nd price rule, with one slot being auctioned off by payment, one by lottery, and the allocation rule follows the initial description above. Moreover, it assumes truthful bidding for all players. We do not cover the construction of strategies for players here for time and space reasons. You find details in the repo.

If you execute the command above, you get the following back: 

      ----Analytics begin----
      Strategies are NOT in equilibrium. Consider the following profitable deviations: 

      Player: Alice
      Optimal move: 20.0
      Current Strategy: fromFreqs [(30.0,1.0)]
      Optimal Payoff: 19.333333333333332
      Current Payoff: 17.92592592592592
      Observable State: ("Alice",30.0)
      Unobservable State: "(((),((\"Alice\",30.0),(\"Bob\",20.0),(\"Carol\",20.0))),(\"Alice\",30.0))"
      --other game-- 
      (... more output ...)

This output tells you first and foremost, truthful bidding is not an equilibrium strategy. But it gives you more information. The player with name Alice has a profitable deviation. Here, if Alice observes a value of 30 (_Observable State_), then instead of playing truthfully, i.e. bidding 30 with certainty (_Current Strategy_), moving to a bid of 20 would be better in expectations (_Optimal move_). The output further gives you the expected payoff and the expected payoff if Alice deviated to the optimal move.

Similar to this one case, the system outputs information for all players and all states (truncated here). 

Now, the result is not surprising. Due to the lottery the incentive to bid truthfully, which may be present in a standard second price auction format, is affected. As a bidder, you may speculate that with some probability you get chosen by the lottery. This in turn may reduce your bids. 

Before we add another test for that auction format, let us actually verify that the truthful bidding is an equilibrium strategy if we consider the standard 2nd price setting. Hence, we fire the following query:

     generateIsEq $ equilibriumGame 2 1 0 noLotteryPayment truthfulStrat
     
Here, we only allocate one token, no token through lottery and also change the payment function. Only the price matters. We get the following output: 

     ----Analytics begin----
     Strategies are in equilibrium
     NEWGAME: 

     Strategies are in equilibrium
     NEWGAME: 

     Strategies are in equilibrium
     NEWGAME: 
     ----Analytics end----

The message should be clear. In the standard setting, the auction code we have set up has indeed an equilibrium with truthful bidding.

Ok, but now back to the original format. What constitutes an equilibrium when we have a lottery? Well, to begin with, when looking at Alice's deviation above, we can see that for a given value she has an incentive to lower her bid. So, maybe we should consider bids which are biased downwards. You can in fact use our system to hone in on possible candidate strategies (it goes without saying that this depends on the kind of game you are investigating). 

If you do this, you can actually identify a threshold strategy. Which means, that the agent bids two values, one for valuations below a threshold, and one for valuations above his threshold. We denote this with `thresholdStrat`. Again, for the details, please check out the repo. We can run: 

    generateIsEq $ equilibriumGame 2 1 1 lotteryPayment thresholdStrat

And get: 

    ----Analytics begin----
    Strategies are in equilibrium
    NEWGAME: 

    Strategies are in equilibrium
    NEWGAME: 

    Strategies are in equilibrium
    NEWGAME: 
    ----Analytics end---

Which shows us indeed that this is an equilibrium. 

This last test took the format as given and asked what an equilibrium strategy looks like. But we can also put ourselves in the shoes of the designer and ask: can we change the payment scheme so that the auction has an equilibrium where players bid truthfully?

Given the issue observed above, where players have an incentive to reduce their bids, it is natural to check whether a reduction of payments restores a truthful bidding equilibrium. 

`lotteryPayment2` implements such a mechanism. We provide details in the repo.

If we test this scheme with the initial strategy (that was not an equilibrium), i.e.


    generateIsEq $ equilibriumGame 2 1 1 lotteryPayment2 truthfulStrat

then we get the following result: 

    ----Analytics begin----
    Strategies are in equilibrium
    NEWGAME: 

    Strategies are in equilibrium
    NEWGAME: 

    Strategies are in equilibrium
    NEWGAME: 
    ----Analytics end---


We hope you get at least a rough idea of how you can use the system to model. We believe that turning modelling into modular programming should speed up the iteration through different scenarios. 

When it comes to the design of smart contracts, we envision our system as a support system which helps to test designs. Like software testing, our system helps to avoid bugs -- on the incentive layer.

Like testing, it is of course no free pass. It can only detect problems, never prove correctness. But if the development of many incentives test is fast, it can help to improve the quality of designs.


## Future extensions

In this post, we have focused the queries of games to equilibrium checking. The tool also supports a simulation functionality. You can simulate the plays of a game for a given strategy.

Regarding the analytics displayed, we only showed parts of it. It is possible to extract more information. For instance, for a given player and given strategy tuple, we get access to his _unilateral deviation context_. This is a function that maps a player's action into his payoffs (fixing the actions of the other players). For instance, in the auction above, we can look at Alice's context while fixing Bob's and Carol's strategy. 

One can therefore analyze the forces working on a given player and experiment with changing actions to see how this affects his payoffs. 

What is key, this unilateral deviation context is generated by the compiler. In principle, there could be many players interacting. The system threads together all the information and the mechanics of the game, the payoff function etc. so that we end up with one function that maps actions of one player into his expected payoffs. 

The auction example above is representative for many similar problems that come up in the design of smart contracts. Whenever there is some allocation mechanism being implemented and it is important to analyze the incentives for agents, our tool can in principle help.
Another domain of possible application concerns the level of protocol design, e.g. staking mechanisms. The proper balancing of incentives for the different players involved is of course essential for the proper working of a given protocol. Our tool can help to find robust designs of such systems. We have started working on such applications.

If you are interested and want to learn more about our software system, the repo contains a tutorial which explains in more detail how modelling works in our system. It also points to further background material. Lastly, watch that space, we are continuously extending the system.


## Notes

[^backgroundReading]: The most relevant articles are: [Compositional game theory](https://arxiv.org/abs/1603.04641) and [Bayesian open games](https://arxiv.org/abs/1910.03656). See also Jules Hedges' [webpage](https://julesh.com/2017/11/09/compositional-game-theory-reading-list/) which contains further resources. 

[^auctionRepoPointer]: The code for this example can be found [here](https://github.com/philipp-zahn/open-games-hs/tree/master/src/Examples/Auctions).

[^TheoryPaper]: This example is inspired by the mechanism discussed in this [paper](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3049504).






