using PowerAnalyses
using Test: @testset, @test

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

    # G*Power gives 0.77; they seem to calculate the noncentrality_parameter differently.
    # pwr.t.test(n=50, d=0.5, sig.level=NULL, power=0.95, type="two.sample", alternative="two.sided")
    @test get_alpha(IndependentSamplesTTest(two_tails); es, power, n) ≈ 0.392 atol=0.01
    # Same as the one sample t-test.
    @test get_alpha(DependentSamplesTTest(two_tails); es, power, n) ≈ 0.067 atol=0.01

    n_groups = 2
    # @test get_power(ANOVATest(n_groups); es, alpha, n) ≈ 0.998 atol=0.001
    # @test get_alpha(ANOVATest(n_groups); es, power, n) ≈ 0.001 atol=0.001

    df = 5
    @test get_power(GoodnessOfFitChisqTest(df); es, alpha, n) ≈ 0.787 atol=0.001
    @test get_alpha(GoodnessOfFitChisqTest(df); es, power, n) ≈ 0.253 atol=0.001
    @test get_es(GoodnessOfFitChisqTest(df); alpha, power, n) ≈ 0.629 atol=0.001
    @test get_n(GoodnessOfFitChisqTest(df); alpha, power, es) ≈ 79.12 atol=0.001

    @test get_alpha(ConstantVarianceChisqTest(one_tail); es, power, n) ≈ 0.038 atol=0.001

    # TODO: Add test for PointBiseralTTest
end
