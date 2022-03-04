using Distributions
using ZeroInflation
using Test

@testset "ZeroInflation.jl" begin
    @testset "constructing ZeroInflated" begin end

    @testset "accessing ZeroInflated" begin
        d = zeroinflated(Poisson(2.0), 0.5)
        @test params(d) == (2.0, 0.5)
        @test minimum(d) == 0
        @test maximum(d) == Inf

        d = zeroinflated(Normal(), 0.1)
        @test params(d) == (0.0, 1.0, 0.1)
        @test minimum(d) == -Inf
        @test maximum(d) == Inf
    end

    @testset "rand" begin
        @test rand(zeroinflated(Normal(), 1.0)) == 0.0
        @test rand(zeroinflated(Normal(), 0.0)) != 0.0

        @test rand(zeroinflated(Normal(), 0.0)) isa AbstractFloat
        @test rand(zeroinflated(Poisson(1.0), 0.0)) isa Integer
    end
end
