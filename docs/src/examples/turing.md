# Fitting zero-inflated models using Turing.jl
This example shows how you can use `ZeroInflation.jl` to fit zero-inflated models using `Turing.jl`. 

First we need to create some sample data. In this example we will use a simple zero-inflated Poisson model with parameter `\lambda = 5.0` and mixing probability `p = 0.25` and create 2000 samples from this distribution

```@example turing
using Distributions, ZeroInflation

lambda = 5.0
p = 0.25

zero_inflated_poisson = zeroinflated(Poisson(lambda), p)
samp = rand(zero_inflated_poisson, 2_000)
```

In a next step we create a Turing model assuming a a true prior on the Poisson parameter `lambda` and a flat Beta prior in the mixing probability. Then we fit the model to our sampled data `samp`.

```@example turing
using Turing

@model function ZIPoisson(y)
    lambda ~ truncated(Normal(5.0, 1.0), 0, Inf)
    p ~ Beta(1, 1)
    
    for n in 1:length(y)
        y[n] ~ zeroinflated(Poisson(lambda), p)
    end
end

model = ZIPoisson(samp)
chain = sample(model, NUTS(0.65), 2_000)
```
