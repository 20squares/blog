---
layout: post
title:  "Decoding the Dual Governance Mechanism: A (Compositional) Game-Theoretic Deep Dive"
author: Philipp Zahn
categories: ["mechanism design", "Lido", "dual-governance"]
excerpt: A game-theoretic analysis of Lido's proposed Dual Governance Mechanism using our Compositional Game Theory Engine
usemathjax: true
thanks: "XXX"
---


Lido’s governance structure has long been built on a multi-layered approach:

- **Lido DAO & LDO Voting:** The core governance body uses LDO token voting to approve proposals.
- **Easy Tracks:** This optimistic voting system handles routine, low-impact changes and reverts to standard voting if any LDO holder objects.
- **Gate Seal Emergency Committee:** In critical moments, this committee can pause certain protocol functions (like withdrawals) for a set period, giving the DAO time to deliberate. Note that the committee can only pause once before needing re-election.

**Enter the Dual Governance Mechanism:**
This new iteration gives stakers a direct role in protocol governance by allowing them to block DAO decisions and act as a negotiation channel between stakers and the DAO. It’s designed to safeguard (w)stETH holders from harmful proposals while maintaining the integrity and forward progress of the protocol.

We were tasked with analyzing the proper working of the mechanism. Which to a large degree means to check the incentives of the different stakeholders involved.

For the game theoretic analysis we have used our own tooling - compositional game theory. Compositional game theory is both a formal language as well as a programming language implemented in our own [stack](https://github.com/CyberCat-Institute/open-game-engine).

In the following, we will illustrate the usage of the tool for analyzing the mechanism. And what can be learned from this analysis. We will only highlight one aspect - the subtle role of coordination. The whole report and further analyses can be found [here](https://github.com/20squares/dual-governance-public).

Note that we have previous posts about our tooling: [A software engine for game theoretic modelling](https://statebox.org/blog/compositional-game-engine/) and [A software engine for game theoretic modelling part 2](https://cybercat.institute/2022/06/24/a-software-engine-for-game-theoretic-modelling-part-2/). These post contain further pointers to background material.

## Dual Governance Mechanism - Background

Lido’s Dual Governance Mechanism introduces a new layer to protocol governance that empowers stakers to directly safeguard their interests.  This mechanism is designed to complement existing governance structures, such as LDO voting, Easy Tracks, and the Gate Seal emergency committee, by providing an additional means for stakeholder protection and negotiation.

The main idea of this contract is that (w)stETH holders can (i) trigger a temporary pause for the decision-making of the DAO ("veto-signalling") as well as (ii) in the extreme leave the system without being subject to proposed decisions by the DAO ("rage-quit").

The core of the mechanism is a contract that implements a state machine where the protocol transitions between different operational states. Initially, proposals progress in a normal state, but when veto-signaling is triggered, the mechanism shifts into a paused state for further evaluation. 

Veto-signaling serves as an early-warning system that allows stakers to express their concerns about a proposal. When a proposal is introduced that raises red flags, stakers can trigger veto-signaling by sending their (w)stETH into the Dual Governance Mechanism's contract, which temporarily halts the proposal’s progress. This pause gives stakeholders the time needed to carefully assess the proposal and coordinate an appropriate response. If, upon further review, the proposal is deemed too harmful, the system can either escalate the issue or maintain the pause until further actions are decided. On the other hand, if the concerns are mitigated, the process can resume as normal.

If the situation escalates, the state may move to a rage-quit state, reflecting a more significant collective dissent among stakers. The rage-quit stage provides stakers with an exit option. When faced with a proposal that they strongly oppose, stakers can choose to initiate a rage-quit, withdrawing their staked (w)stETH into an escrow where the tokens will be exchanged against ETH. Although this action comes with costs such as opportunity costs or temporary market risks, it serves as a clear signal of dissent. By exiting, stakers not only protect their own assets but also exert pressure on the DAO to reconsider or modify proposals that could be detrimental to the protocol.

The key parameter for the mechanism is `RageQuit`  support ($R$) which measure the ratio between the value of (w)stETH sent into the escrow and the tokens overall in circulation. It is evidently a measure discontent with proposals. This parameter is used to determine when a state transition from the normal functioning of DAO happens. One key threshold is the `FirstSealRageQuitSupport` which once crossed triggers the `VetoSignalling` state and `SecondSealRageQuitSupport` once crossed triggers the (final) `RageQuit` stage.

The state machine provides additional states that regulate the de-escalation. Also the state transitions depend on more parameters and has time requirements. The mechanism must spend a certain amount of time a state before a transition can happen (e.g. from `VetoSignalling` to `RageQuit`). We will ignore all of this to keep things simple.

## A game theoretic model - overview

The key question we want to tackle here is: Under which conditions does the mechanism work as expected? We will focus on one specific aspect, namely do stakers have appropriate incentives to stake into the escrow. We will answer this question with a series of simple models.

The essence of Compositional Game Theory is that models are built in a compositional manner by plugging things together. And as in our case model=code, "things" is code. In the following we first give a high level overview of the model, i.e. code-base.

At the core, the repository contains a comprehensive game theoretic model that simulates the interactions within the dual governance mechanism. Detailed explanations accompany each part of the model, helping to clarify how each component contributes to our understanding of the system. The model not only represents the on-chain interactions but also extends to analyze off-chain components and interactions where necessary.

The game theory model is structured to capture a sequence of interactions between the DAO and the dual governance module. 

#### State Machine Components

The dual governance mechanism is implemented as a state machine. This is a critical design choice because it allows us to mirror the strategic transitions that occur as stakeholders react to DAO proposals. The state machine’s logic is encapsulated in the `SupportFunctions.hs` file, which serves as the backbone of our model by handling state transitions and the timing of these transitions. This approach not only simplifies the representation of the mechanism but also provides clarity on how state changes affect the strategic behavior of all actors involved.

#### Models, Components, and Payoffs

Our model breaks down the complex interactions into several key components. The primary modules are found in `Components.hs`, which outlines how the DAO votes and executes actions, and in `Model.hs`, where these subgames are assembled into a comprehensive model. The aim here is to capture a range of strategic scenarios in a way that is both accessible and analyzable from a game theory perspective.

Payoffs are a central part of our analysis. They represent the potential losses or gains that agents—like our representative “Alice”—might experience if a particular DAO proposal were to harm their (w)stETH holdings. In our code, the payoff functions are defined in `Payoffs.hs`, where we account for both objective risks (such as a drop in asset value) and subjective, privately known beliefs about a proposal’s impact. This layered approach allows us to incorporate heterogeneity in agent beliefs and private signals, with changes to the model being as simple as tweaking the `computeAssetsAtRisk` function in `SupportFunctions.hs`.

#### File Structure

Our analysis is composed of several files. The code proper is contained in the `src` folder:
- `ActionSpace.hs` is mainly needed for technical type-transformations. It maps a player's decision type into the type needed to be fed in the subsequent game.
- `Analytics.hs` defines the equilibrium notion for each game we want to test.
- `Components.hs` is where the subgames making up the whole model are defined.
- `Model.hs` is the file where the subgames are assembled and the main model is defined.
- `Parametrization.hs` defines the concrete parametrizations used for the analysis. This comprises all the parameters defining the initial state of the model, as for instance may be players' initial endowments, weights in a payoff matrix, fixed costs to perform some operations, etc.
- `Payoffs.hs` is where the payoff functions used in every (sub)game are defined. We decided to keep them all in the same file to make tweaking and fine-tuning less dispersive.
- `Strategies.hs` is where the strategies we want to test are defined.
- `SupportFunctions.hs` is where we defined some plain-Haskell functions that are going to be used in the model. Here, for instance, the main logic of the dual governance state machine is implemented.
- `Types.hs` is where we define the types for the main ingredients of the model. As it can grow very complex, enforcing some type discipline either by means of simple type-aliasing or by defining new types helps to contain sources of errors.

## Model Components

As mentioned before, the core logic of the state machine is replicated in `SupportFunctions`. Note that this requires significant work to mirror the specification. We will not touch on this and directly jump into the main model components:

```haskell
-- Decision of representative stETH holder (aka staker) to lock or unlock funds from signalling escrow
-- Includes payoff adjustment from locked or unlocked funds
stakingGame :: (Eq a, Show a)
            => GovernanceParams
            -> Agent
            -> [Double]
            -> OpenGame StochasticStatefulOptic
                        StochasticStatefulContext
                       '[Kleisli Stochastic (CurrentProposal a, OpportunityCosts, RiskFactor) Double]
                       '[[DiagnosticInfoBayesian (CurrentProposal a, OpportunityCosts, RiskFactor) Double]]
                        (GlobalLidoState, TimeAbsolute, SignallingEscrowState, GovernanceState, GovernanceValues, CurrentProposal a, OpportunityCosts, RiskFactor)
                        ()
                        (SignallingEscrowState, GovernanceState, GovernanceValues)
                        Payoff
stakingGame governanceParams stakingAgent actionSpace  = [opengame|
  inputs: globalLidoState, currentTime, currentSignallingEscrowState, currentDGState, currentDGValues, proposal, opportunityCostFactor, agentRiskFactor;
  feedback: ;

  :---:

  // Decision of amount to stake or unstake from signalling escrow
  inputs: proposal, opportunityCostFactor, agentRiskFactor;
  feedback: ;
  operation: dependentDecision stakingAgent (const actionSpace);
  outputs: amountStaked;
  returns: agentPayoff - costsOfStaking;

  // Compute costs of transferring into the escrow
  inputs:  opportunityCostFactor, amountStaked;
  feedback: ;
  operation: forwardFunction computeRiskCosts;
  outputs: costsOfStaking;
  returns: ;

  // Transfer funds between staker's wallet and signalling escrow
  inputs: amountStaked, globalLidoState, currentSignallingEscrowState;
  feedback: ;
  operation: fromFunctions (\(amountStaked, globalLidoState, currentSignallingEscrowState) 
                           -> stakeOrUnstake stakingAgent amountStaked globalLidoState currentSignallingEscrowState) id;
  outputs: (newGlobalLidoState, newSignallingEscrowState);
  returns: ;

  // Compute actual payoffs as own assets at risk
  inputs: newGlobalLidoState, agentRiskFactor ;
  feedback: agentPayoff ;
  operation: fromLens id (computeAssetsAtRisk stakingAgent) ;
  outputs: discard ;
  returns: payoff;

  :---:

  outputs: newSignallingEscrowState, currentDGState, currentDGValues;
  returns: payoff;
|]
```
`stakingGame` defines the decision-making process for a representative stETH holder (staker) as they choose whether to lock or unlock funds in the signalling escrow, a key component of Lido’s Dual Governance Mechanism. 

The process begins by taking several inputs such as the current global Lido state, current time, the signalling escrow state, the dual governance state and values, the active proposal, the opportunity cost factor, and a risk factor. These inputs set the stage for simulating the staker’s actions and the subsequent state transitions.

The game is structured into four main stages:

1. **Staking Decision:**  
   The staker decides how much to stake or unstake from the signalling escrow. This decision is modeled by a dependent decision operation that considers the current proposal, opportunity cost, and risk factor. The chosen amount, `amountStaked`, directly influences the preliminary calculation of the agent's payoff, which is defined as the payoff minus the costs of staking.

2. **Cost Computation:**  
   After the decision is made, the model computes the costs associated with transferring funds into the escrow. This computation uses the `computeRiskCosts` function, which factors in the opportunity cost and the staked amount to determine the cost of staking.

3. **Funds Transfer:**  
   The next stage involves updating the state to reflect the transfer of funds. The code calls a function (`stakeOrUnstake`) that moves funds between the staker’s wallet and the signalling escrow. This operation results in updated global Lido and signalling escrow states.

4. **Payoff Calculation:**  
   Finally, the model calculates the actual payoff for the staker based on their assets at risk. This step uses the `computeAssetsAtRisk` function, which leverages the updated global state and the agent’s risk factor to compute the final payoff.

Regarding the payoff, here we make the assumption that the agent trades-off the risk of losing value due to the assets he already has or sending the assets to escrow and possibly avoiding loss - but accepting costs for staking.

The game concludes by outputting the new signalling escrow state along with the unchanged dual governance state and values. The final return value of the game is the staker’s computed payoff.

Next, we need to model the DAO:

```haskell
-- Decision of DAO to modify the state of a proposal
daoVoting :: (Show a, Eq a) => GovernanceParams -> Agent
          -> OpenGame StochasticStatefulOptic
                      StochasticStatefulContext
                      '[Kleisli Stochastic (CurrentProposal a) AllDAOActions]
                      '[[DiagnosticInfoBayesian (CurrentProposal a) AllDAOActions]]
                      (TimeAbsolute, GovernanceState, CurrentProposal a)
                      ()
                      (TimeAbsolute, CurrentProposal a)
                      Payoff
daoVoting governanceParams daoAgent = [opengame|
    inputs: currentTime, governanceState, proposal ;
    feedback: ;

    :---:

    // DAO votes to submit, cancel or execute the current proposal
    inputs: proposal;
    feedback: ;
    operation: dependentDecision daoAgent (const allDAOActions);
    outputs: decision;
    returns: payoff;

    // DAO implements the chosen action if able
    inputs: governanceParams, currentTime, governanceState, proposal, decision;
    feedback: ;
    operation: forwardFunction (\(governanceParams, currentTime, governanceState, proposal, decision) 
                               -> daoDoMove governanceParams currentTime governanceState proposal decision);
    outputs: newTime, updatedProposal;
    returns: ;

    :---:

    outputs: newTime, updatedProposal;
    returns: payoff;
  |]

```

`daoVoting`, represents the DAO's vote as it chooses to either submit, cancel, or execute a proposal, encapsulated within a game-theoretic framework.

The process begins by taking inputs such as the current time, the current governance state, and the active proposal. The DAO agent then makes a decision from a set of possible actions (captured by `allDAOActions`) using a dependent decision operation. This decision-making step produces an output referred to as `decision`, along with an immediate payoff for the DAO.

Following the decision, the chosen action is implemented through a forward function. This function calls `daoDoMove`, which applies the DAO's decision to the current governance parameters, time, state, and proposal. As a result, the game transitions to a new state by updating the current time and modifying the proposal accordingly.

Ultimately, the `daoVoting` function outputs the updated time and the revised proposal, while also returning the computed payoff for the DAO. This snippet, much like the staking game component, illustrates how strategic decisions and state transitions are modeled within the dual governance mechanism.

Next, we combine the DAO process and stakers together into one game.

```haskell
-- Variant of DAO-staker game with 2 heterogenous staking agents
-- (aka representatives of 2 classes of stakers)
dao2StakersGame :: (Eq a, Show a) 
                => GovernanceParams
                -> Agent
                -> (Agent, Agent)
                -> [Double]
                -> OpenGame StochasticStatefulOptic
                            StochasticStatefulContext
                            '[Kleisli Stochastic (CurrentProposal a) AllDAOActions,
                              Kleisli Stochastic (CurrentProposal a, OpportunityCosts, RiskFactor) Double,
                              Kleisli Stochastic (CurrentProposal a, OpportunityCosts, RiskFactor) Double]
                            '[[DiagnosticInfoBayesian
                                 (CurrentProposal a) AllDAOActions],
                              [DiagnosticInfoBayesian (CurrentProposal a, OpportunityCosts, RiskFactor) Double],
                              [DiagnosticInfoBayesian (CurrentProposal a, OpportunityCosts, RiskFactor) Double]]
                            (GlobalLidoState, TimeAbsolute, SignallingEscrowState,
                             GovernanceState, GovernanceValues, CurrentProposal a,
                             (OpportunityCosts, OpportunityCosts), (RiskFactor, RiskFactor))
                            ()
                            (TimeAbsolute, SignallingEscrowState, GovernanceState,
                             GovernanceValues, CurrentProposal a)
                            (Payoff, Payoff, Payoff)
dao2StakersGame governanceParams daoAgent (stakingAgent1, stakingAgent2) actionSpaceStaker
  = [opengame|
  inputs: globalLidoState, time, signallingEscrowState, governanceState, governanceValues, proposal, opportunityCostFactors, agentRiskFactors;
  feedback: ;

  :---:

  // DAO chooses & implements move
  inputs: time, governanceState, proposal;
  feedback: ;
  operation: daoVoting governanceParams daoAgent;
  outputs: time', proposal';
  returns: daoPayoff;

  // Staker 1 chooses & implements move
  inputs: globalLidoState, time, signallingEscrowState, governanceState, governanceValues, proposal', fst opportunityCostFactors, fst agentRiskFactors;
  feedback: ;
  operation: stakingGame governanceParams stakingAgent1 actionSpaceStaker;
  outputs: signallingEscrowState', governanceState', governanceValues';
  returns: staker1Payoff;

  // Staker 2 chooses & implements move
  inputs: globalLidoState, time, signallingEscrowState', governanceState', governanceValues', proposal', snd opportunityCostFactors, snd agentRiskFactors;
  feedback: ;
  operation: stakingGame governanceParams stakingAgent2 actionSpaceStaker;
  outputs: signallingEscrowState'', governanceState'', governanceValues'';
  returns: staker2Payoff;

  // Both agents wait for time to pass
  inputs: globalLidoState, time', signallingEscrowState'', governanceState'', governanceValues'';
  feedback: ;
  operation: forwardFunction (\(globalLidoState, time', signallingEscrowState', governanceState', governanceValues') -> transitionWithTime globalLidoState governanceParams time' signallingEscrowState' governanceState' governanceValues');
  outputs: time'', governanceState''', governanceValues''';
  returns: ;

  :---:

  outputs: time'', signallingEscrowState'', governanceState''', governanceValues''', proposal';
  returns: daoPayoff, staker1Payoff, staker2Payoff;
|]
```

This function models an extended game where the DAO and two heterogeneous stakers interact sequentially. First, the DAO makes a move on the current proposal using its voting mechanism, which updates the time and the proposal state while yielding a DAO payoff. Next, the first staker acts by deciding how much to stake or unstake based on its own opportunity cost and risk factors; this action updates the signalling escrow, governance state, and governance values, and produces a payoff for the first staker. Then, the second staker takes a similar action with its corresponding parameters, further updating the system state and generating its own payoff. Finally, the game advances time using a transition function that reflects the passage of time on the updated state. The overall output of the game is the new time, updated states, and the individual payoffs for the DAO, staker one, and staker two.

## Model

Equipped with these basic building blocks we can now assemble the main model we will work with: 

```haskell
-- Variant of modelBasic2 with 2 staking agents, ie. representatives of 2 classes of stakers
modelHeterogenous :: GovernanceParams
                  -> Agent
                  -> (Agent, Agent)
                  -> [Double]
                  -> OpenGame
                       StochasticStatefulOptic
                       StochasticStatefulContext
                       '[Kleisli Stochastic (CurrentProposal ProposalModel) AllDAOActions,
                         Kleisli Stochastic (CurrentProposal ProposalModel, OpportunityCosts, RiskFactor) Double,
                         Kleisli Stochastic (CurrentProposal ProposalModel, OpportunityCosts, RiskFactor) Double,
                         Kleisli Stochastic (CurrentProposal ProposalModel) AllDAOActions,
                         Kleisli Stochastic (CurrentProposal ProposalModel, OpportunityCosts, RiskFactor) Double,
                         Kleisli Stochastic (CurrentProposal ProposalModel, OpportunityCosts, RiskFactor) Double]
                       '[[DiagnosticInfoBayesian (CurrentProposal ProposalModel) AllDAOActions],
                         [DiagnosticInfoBayesian (CurrentProposal ProposalModel, OpportunityCosts, RiskFactor) Double],
                         [DiagnosticInfoBayesian (CurrentProposal ProposalModel, OpportunityCosts, RiskFactor) Double],
                         [DiagnosticInfoBayesian (CurrentProposal ProposalModel) AllDAOActions],
                         [DiagnosticInfoBayesian (CurrentProposal ProposalModel, OpportunityCosts, RiskFactor) Double],
                         [DiagnosticInfoBayesian (CurrentProposal ProposalModel, OpportunityCosts, RiskFactor) Double]]
                       (GlobalLidoState, TimeAbsolute, SignallingEscrowState,
                        GovernanceState, GovernanceValues, CurrentProposal ProposalModel,
                        (OpportunityCosts, OpportunityCosts), (RiskFactor, RiskFactor))
                       ()
                       (TimeAbsolute, SignallingEscrowState, GovernanceState,
                        GovernanceValues, CurrentProposal ProposalModel)
                       (CurrentProposal ProposalModel)
modelHeterogenous governanceParams daoAgent stakingAgents actionSpaceStaker = [opengame|
  inputs: globalLidoState, time, signallingEscrowState, governanceState, governanceValues, proposal, opportunityCostFactors, agentRiskFactors;
  feedback: ;

  :---:

  inputs: globalLidoState, time, signallingEscrowState, governanceState, governanceValues, proposal, opportunityCostFactors, agentRiskFactors;
  feedback: ;
  operation: dao2StakersGame governanceParams daoAgent stakingAgents actionSpaceStaker;
  outputs: time', signallingEscrowState', governanceState', governanceValues', proposal';
  returns: 0, 0, 0; // Payoffs in this component are handled by implicit state

  inputs: globalLidoState, time', signallingEscrowState', governanceState', governanceValues', proposal', opportunityCostFactors, agentRiskFactors;
  feedback: ;
  operation: dao2StakersGame governanceParams daoAgent stakingAgents actionSpaceStaker;
  outputs: time'', signallingEscrowState'', governanceState'', governanceValues'', proposal'';
  returns: evaluateProposalLDOs finalProposal, evaluateProposalStakers finalProposal, evaluateProposalStakers finalProposal ;

  :---:

  outputs: time'', signallingEscrowState'', governanceState'', governanceValues'', proposal'';
  returns: finalProposal;
|]
```

This model sequentially binds together two of the `dao2StakersGame` primitives. This resembles the idea that the DAO makes a proposal; stakers respond. After a first round, the game repeats itself with the DAO possibly updating the proposal and the stakers again responding. Note, that outcome of the game is not fully concluded as it rests on a further input from the future, `finalProposal`. In this way we can analyze the game by imposing different continuations. E.g. by assuming that the proposal eventually gets canceled.

The final output is the updated time, escrow state, governance state and values, and the final proposal, which collectively reflect the evolution of the system under the influence of both the DAO and the two heterogeneous stakers.

## Analysis

The gist of our analysis is to test whether specific behavior of the agents is in equilibrium. Technically, this is implemented by using Haskell's testing framework: A specific game is defined, the testing suite verifies that the game is in equilibrium - possibly checking for a whole range of parameters. Details of the tests can be found under `/tests`. All tests are instantiated with the default parameters from the spec. You can assume for now that any test mentioned here passes.

We will focus on one aspect: Under which conditions do have two (representative) heterogeneous agents an incentive to stake? At first, this seems like a rather harmless question. But as we will see things are more subtle.

In the following, we always consider the situation where the DAO introduces a malicious proposal that will possible destroy the value of the assets held by token holders. The key question is whether the stakers send their tokens into the contract. Let's start slowly and with some sanity checks.

Consider a thought experiment. What if staking into the Dual Governance Mechanism contract is without costs? Well, in this case, it does not really matter for agents whether to use the contract. So, basically almost any move by agents should be in equilibrium. The key thing therefore are the costs relative to the benefits.

```haskell
-- With a given negative payoff from a proposal, not staking is the right choice as staking creates costs but does not prevent the proposal.
prop_StakingGameEq =
  eqEquilibriumStakingGame simpleStakingGameParameters (minStakingStrategyTuple stakerMoves) === True

-- With a given negative payoff from a proposal, minimal staking is the right choice as here the staking prevents the negative consequences
prop_StakingGameEq2 =
  eqEquilibriumStakingGame2 simpleStakingGameParameters (optimalStakingStrategyRageQuitTuple stakerMoves simpleStakingGameParameters) === True

```
The way to read this test is that `eqEquilibriumStakingGame ...` represents the Boolean property of the staking game being in equilibrium. As long as the test evaluates to `True`, the test will pass. (Again, we assume that the test passes).

The first test verifies that if an agent bears costs but cannot influence the outcome of the mechanism (cannot bring about a state change), he has no incentive to use the mechanism (and send his tokens there).

The second tests then verifies that if an agent _can_ influence the state change and in this case avoid a total loss of assets, he will just transfer the minimum amount into the contract triggering the change.

While simple, this illustrates already an important point. Even in the case of a single agent, the agent faces tradeoffs. Depending on beliefs about what is going to happen, it can make sense to transfer into the contract or not.

Now, let's turn to a setting with heterogenous agents. 
```haskell
-- In this game both agents stake
prop_ModelHeterogenousGameNegativeForStakersEq payoffLDO payoffStETHHolders =
  payoffLDO > 0 && payoffStETHHolders < 0 ==>
  eqEquilibriumModelHeterogenousGame params (modelHeterogenousProposeExecuteOptimalMinStakingStrategy stakerMoves params) === True
  where params = (modelHeterogenousGameParametersTestProposal payoffLDO payoffStETHHolders)

-- In this game one agent stakes alone
prop_ModelHeterogenousGameNegativeForStakersEq2 payoffLDO payoffStETHHolders =
  payoffLDO > 0 && payoffStETHHolders < 0 ==>
  eqEquilibriumModelHeterogenousGame params (modelHeterogenousProposeExecuteOptimalMinStakingStrategy2 stakerMoves params) === True
  where params = (modelHeterogenousGameParametersTestProposal payoffLDO payoffStETHHolders)
```

In these two cases, we consider stakers to be symmetric - affected in the same way and also being perfectly informed about how they are affected and in addition having common knowledge about this fact. In the first game, both stakers share the burden of sending sufficient tokens. In the second case, only one staker stakes - the other stakes nothing. Two things are important: Without the actual threat of an execution of the proposal no agent will stake. Second, there is a coordination issue: Agent Bob would actually prefer if Alice were to stake and to prevent the execution of the proposal. 

In traditional game theoretic fashion, we are imposing the strategies and show that they are in equilibrium if agents know these strategies are played. In practice though this poses a significant challenge as it is absolutely not obvious how to coordinate. The code-base considers various extensions of this.

Instead of going through this, we want to illustrate another point. So far we assumed that agents are perfectly informed. Now, we consider asymmetric information. The code-base contains various models, here we will focus just on one setting:  Let us illustrate the latter point with an extension. 













Would it not make sense to use the actual contracts after all they are already implemented? Yes and no. First, note that it is not 100% clear on what the model should be based. After all implementation and spec might diverge. one needs to find a way to connect 

The mechanism works well for obvious threats: malicious proposals with clear, negative outcomes for stakeholders. Here, the equilibrium strategies for stakeholders are straightforward: signal veto or rage-quit to protect their assets.

However, coordination becomes a challenge when proposals are ambiguous. Stakeholders face **free-rider problems**: everyone benefits from halting a harmful proposal, but no one wants to bear the cost of staking tokens in the escrow. Add subjective beliefs about proposal risks, and strategic uncertainty escalates.

In game-theoretic terms, the mechanism operates like a public good: the incentive to protect the protocol is collective, but individual costs (e.g., opportunity costs of staked tokens) deter action. This creates a risk where the mechanism fails not due to design flaws but due to coordination breakdowns.

### New Attack Vectors: State Oscillations

While the mechanism strengthens stakeholder defenses, it also expands the strategic surface for attacks. The key vulnerability lies in **state oscillations**: repeated transitions between veto-signaling and normal states. This cycling creates complexity, increasing the likelihood of delayed or blocked proposals. For example:
- A malicious actor could exploit veto-signaling windows to slow DAO decisions.
- An attacker could trigger prolonged pauses, creating backlogs of proposals and manipulating decision fatigue to pass harmful changes.

This is compounded by the introduction of committees, which, while addressing deadlocks, open avenues for bribery or collusion. With voting thresholds and committee compositions only partially defined, the system’s long-term stability hinges on robust parameter choices.
