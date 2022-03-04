module ZeroInflation

using Distributions
using LogExpFunctions
using Random

export ZeroInflated
export zeroinflated

struct ZeroInflated{D<:UnivariateDistribution,S<:ValueSupport,T<:Real} <: UnivariateDistribution{S}
  original::D
  θ::T
  p::T
  link::Function
  function ZeroInflated(d::UnivariateDistribution, θ::T, link = identity) where {T<:Real}
    p = link(θ)
    @assert 0.0 <= p <= 1.0
    new{typeof(d),Distributions.value_support(typeof(d)),typeof(p)}(d, θ, p, link)
  end
end

Distributions.params(d::ZeroInflated) = tuple(Distributions.params(d.original)..., d.link(d.p))

Distributions.minimum(d::ZeroInflated) = min(minimum(d.original), 0)
Distributions.maximum(d::ZeroInflated) = max(maximum(d.original), 0)

function Distributions.logpdf(d::ZeroInflated, x::Real)
  p = d.p
  if x == 0
    loglik = [
      logpdf(Bernoulli(p), 1),
      logpdf(Bernoulli(p), 0) + logpdf(d.original, x)
    ]
    return logsumexp(loglik)
  else
    return logpdf(Bernoulli(p), 0) + logpdf(d.original, x)
  end
end

Distributions.pdf(d::ZeroInflated, x::Real) = exp(logpdf(d, x))

function Distributions.rand(rng::Random.AbstractRNG, d::ZeroInflated)
  c = rand(rng, Bernoulli(d.p))
  return c == 1 ? zero(eltype(d.original)) : rand(rng, d.original)
end

zeroinflated(d::UnivariateDistribution, p::T; link = identity) where {T<:Real} = ZeroInflated(d, p, link)

end
