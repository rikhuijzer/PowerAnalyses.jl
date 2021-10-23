using PowerAnalyses
using Test:
    @testset,
    @test

@testset "t-test" begin
    es = 0.5
    alpha = 0.05
    power = 0.95
    n = 50

    # Values are obtained via `pwr` version 1.3 and `G*Power` version 3.1.9.7.
    @test get_alpha(OneSampleTTest(two_tails); es, power, n) ≈ 0.067 atol=0.001
    @test get_alpha(OneSampleTTest(one_tail); es, power, n) ≈ 0.033 atol=0.001
    @test get_power(OneSampleTTest(two_tails); es, alpha, n) ≈ 0.933 atol=0.001
    @test get_power(OneSampleTTest(one_tail); es, alpha, n) ≈ 0.967 atol=0.001

    # For methods which require `find_zero`, compare the outcome with pwr; G*Power is far off.
    @test get_es(OneSampleTTest(two_tails); alpha, power, n) ≈ 0.520 atol=0.001
    @test get_es(OneSampleTTest(one_tail); alpha, power, n) ≈ 0.471 atol=0.001
    @test get_n(OneSampleTTest(two_tails); alpha, power, es) ≈ 53.941 atol=0.001
    @test get_n(OneSampleTTest(one_tail); alpha, power, es) ≈ 44.679 atol=0.001
end
