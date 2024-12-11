---
layout: post
title:  "Open Games meets HEVM"
author: Andre Videla and Philipp Zahn
categories: Open Games
excerpt: Where we present the XGA project.
usemathjax: true
thanks: Thanks to Daniele Palombi / Lexi / whoelse
---


## 🌟 What’s This About?
This post introduces a powerful integration between the **Open Games Engine** (OGE) and **HEVM**, unlocking new efficiencies and reducing errors in modeling complex systems. We'll walk through the benefits of this integration, address current limitations, and explore an exciting example: the **Dual Governance Project**.

### 🎮 What Is the Open Games Engine?
The Open Games Engine is a flexible, modular framework for modeling **strategic interactions** in blockchain environments. Think of it as a playground where rules and incentives can be designed, simulated, and tested.

Its strength lies in enabling precise analysis of game-theoretic mechanisms, from simple auctions to complex governance schemes. However, **current modeling workflows require a significant amount of manual code implementation**, particularly when it comes to simulating smart contract logic.



### 🔬 What Is HEVM?
**HEVM** (Haskell Ethereum Virtual Machine) is a robust tool for simulating and testing Ethereum smart contracts. It enables developers to execute contract code locally, providing deep insights into behavior and potential issues, all without needing to deploy on-chain.



### ⚠️ The Problem: Manual Implementation
Right now, modeling smart contracts in OGE requires developers to manually reimplement background logic, such as:
- Simulating contract interactions
- Writing mock contracts for testing purposes
- Handling low-level mechanisms like gas fees and reverts

**This approach is time-consuming, error-prone, and often limits the fidelity of simulations.**



### 🔗 The Solution: Integrating OGE with HEVM
By connecting OGE with HEVM, we create a unified pipeline where smart contracts can be:
1. Simulated directly using HEVM's accurate execution environment.
2. Plugged into OGE’s game models **without reimplementation**, ensuring consistency and reducing errors.

This integration streamlines the process, allowing developers to focus on designing and testing mechanisms instead of reinventing the wheel.


### 💡 A Leading Example: Dual Governance Project

To illustrate the power of this integration, we’ll use the **[Dual Governance Project](https://github.com/example/dual-governance-project)** as a running example throughout this post.

This mechanism, intended as a complement to the Lido protocol as a safety module for (w)stETH holders, relies on a series of smart contracts. In the project we did analyze game theoretic properties of this mechanism. To that end we had to implement the whole mechanism, in particular its state machine. This requires a lot of manual work. The state machine alone are around XXX lines of code.

With the OGE x HEVM integration, we can directly import and test the **real contracts**, saving time and enhancing accuracy. 

Now, in the dual governance project as well as in others there is sometimes a good reason to _not_ use the actual implementation but instead work the specification. After all the implementation might not be following the specification but the economic analysis should be base on the _intended_ design. 

Still, in principle, with the integration available, one can in principle also combine the two approaches: One can construct tests where model based implementation are compared with the implementation based analysis. In so far as there arise differences, one can then investigate the reasons for this. This equips the analyses with a very high degree of assurance.

## Intro HEVM

## Intro Open Games

## Simple example using HEVM and Open Games

## Lido example
