module ZeroInflation

using Distributions
using LogExpFunctions
using Random
using Requires
using UnPack

export zeroinflated

struct ZeroInflated{D1<:UnivariateDistribution,D2<:UnivariateDistribution,S<:ValueSupport} <: UnivariateDistribution{S}
    original::D1
    mix::D2
    function ZeroInflated(d::UnivariateDistribution, m::UnivariateDistribution)
        new{typeof(d),typeof(m),Distributions.value_support(typeof(d))}(d, m)
    end
end

Distributions.params(d::ZeroInflated) = tuple(Distributions.params(d.original)..., Distributions.params(d.mix)...)
Distributions.minimum(d::ZeroInflated) = min(minimum(d.original), 0)
Distributions.maximum(d::ZeroInflated) = max(maximum(d.original), 0)

function Distributions.logpdf(d::ZeroInflated, x::Real)
    @unpack original, mix = d
    if x == 0
        loglik = [
            logpdf(mix, 1),
            logpdf(mix, 0) + logpdf(original, 0)
        ]
        return logsumexp(loglik)
    else
        return logpdf(mix, 0) + logpdf(original, x)
    end
end

function Distributions.logpdf(d::ZeroInflated, x::Vector{T}) where {T<:Real}
    @unpack original, mix = d
    N_zero = sum(x .== 0)
    N_nonzero = length(x) - N_zero

    loglik = N_zero * logsumexp([
        logpdf(mix, 1),
        logpdf(mix, 0) + logpdf(original, 0)
    ])
    loglik += N_nonzero * logpdf(mix, 0)
    loglik += sum(logpdf.(original, filter(!iszero, x)))
    return loglik
end

Distributions.pdf(d::ZeroInflated, x::Real) = exp(logpdf(d, x))

function Distributions.rand(rng::Random.AbstractRNG, d::ZeroInflated)
    @unpack original, mix = d
    c = rand(rng, mix)
    return c == 1 ? zero(eltype(original)) : rand(rng, original)
end

"""
    zeroinflated(d::UnivariateDistribution, p::Real)
    zeroinflated(d::UnivariateDistribution, m::UnivariateDistribution)

Construct a zero-inflated distribution. The mixing distribution can be specified using
a mixing probability *p* or a custom mixing distribution *m* (e.g. `Bernoulli(p)``).
"""

zeroinflated(d::UnivariateDistribution, p::Real) = ZeroInflated(d, Bernoulli(p))
zeroinflated(d::UnivariateDistribution, m::UnivariateDistribution) = ZeroInflated(d, m)

end
