using Distributions
using ZeroInflation
using Test
import Turing: BernoulliLogit
import Turing: BinomialLogit

@testset "ZeroInflation.jl" begin
    @testset "constructing ZeroInflated" begin
        d = zeroinflated(Normal(), 0.25)
        @test d isa ZeroInflation.ZeroInflated
        @test d.mix isa Bernoulli
        @test d.mix.p == 0.25
        @test d.original isa Normal

        d = zeroinflated(Normal(), BernoulliLogit(1.0))
        @test d.mix isa BinomialLogit
        @test d.mix.logitp == 1.0
    end

    @testset "accessing ZeroInflated" begin
        d = zeroinflated(Poisson(2.0), 0.5)
        @test params(d) == (2.0, 0.5)
        @test minimum(d) == 0
        @test maximum(d) == Inf

        d = zeroinflated(Normal(), 0.1)
        @test params(d) == (0.0, 1.0, 0.1)
        @test minimum(d) == -Inf
        @test maximum(d) == Inf

        d = zeroinflated(Uniform(-0.5, 0.5), 0.1)
        @test params(d) == (-0.5, 0.5, 0.1)
        @test minimum(d) == -0.5
        @test maximum(d) == 0.5

        d = zeroinflated(Uniform(-2.0, -1.0), 0.1)
        @test minimum(d) == -2.0
        @test maximum(d) == 0.0
    end

    @testset "rand" begin
        @test rand(zeroinflated(Normal(), 1.0)) == 0.0
        @test rand(zeroinflated(Normal(), 0.0)) != 0.0

        @test rand(zeroinflated(Normal(), 0.0)) isa AbstractFloat
        @test rand(zeroinflated(Poisson(1.0), 0.0)) isa Integer
    end

    @testset "logpdf" begin
        d = zeroinflated(Poisson(2.0), 0.2)
        samp = rand(d, 1000)
        pointwise_loglik = logpdf.(d, samp)
        @test length(pointwise_loglik) == length(samp)
        @test isapprox(sum(pointwise_loglik), logpdf(d, samp))
    end
end
