using PowerAnalyses
using Test:
    @testset,
    @test

@testset "PowerAnalyses" begin
    es = 0.5
    alpha = 0.05
    power = 0.95
    n = 50

    # Values are obtained via `pwr` version 1.3.
    @test calculate(OneSampleTTest(two_tails); es, power, n) ≈ 0.067 atol=0.001
    @test calculate(OneSampleTTest(one_tail); es, power, n) ≈ 0.033 atol=0.001
end
