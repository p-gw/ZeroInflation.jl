# ZeroInflation.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://p-gw.github.io/ZeroInflation.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://p-gw.github.io/ZeroInflation.jl/dev)
[![Build Status](https://github.com/p-gw/ZeroInflation.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/p-gw/ZeroInflation.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/p-gw/ZeroInflation.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/p-gw/ZeroInflation.jl)

This package provides simple utilities for constructing zero-inflated distributions.
It is mainly intended to for fitting zero-inflated and hurdle models using `Turing.jl`.

## Basic usage
`ZeroInflation.jl` exports a single function (`zeroinflated`) that can be used to construct arbitrary zero-inflated distributions. For example to construct a zero-inflated Poisson distribution with parameter `λ = 1.0` and mixing probability `θ = 0.2`, call

```
zeroinflated(Poisson(1.0), 0.2)
```

Sometimes it can be useful (e.g. in regression modelling) to express the mixing distribution not in terms of raw probabilities, but on the `logit` scale. In this case the distribution with parameter `λ = 1.0` and mixing probability `θ = logistic(0.0)` can be constructed by

```
zeroinflated(Poisson(1.0), StatsFuns.logistic(0.0))
```

or by directly providing a logit parameterized Bernoulli distribution,

```
zeroinflated(Poisson(1.0), Turing.BernoulliLogit(0.0))
```
.
