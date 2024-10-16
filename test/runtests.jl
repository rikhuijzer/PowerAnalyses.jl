using PowerAnalyses
using Test: @testset, @test

@testset "t-test" begin
    es = 0.5
    alpha = 0.05
    power = 0.95
    n = 50
    N = [n, n]

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

    @testset "IndependentSamplesTTest" begin
        @testset "two_tails" begin
            # This matches pwr.t.test(n=50, d=0.5, sig.level=NULL, power=0.95, type="two.sample", alternative="two.sided")
            # but not power.t.test(n=50, d=0.5, sig.level=NULL, power=0.95, type="two.sample", alternative="two.sided")
            # because the latter considers both sides of the distribution. The pwr.t.test matches # G*Power and is 0.3928954
            @test get_alpha(IndependentSamplesTTest(two_tails); es, power, n) ≈ 0.3928954 rtol=1e-6
            @test get_power(IndependentSamplesTTest(two_tails); es, alpha, n) ≈ 0.6968934 rtol=1e-6
            @test get_es(IndependentSamplesTTest(two_tails); alpha, power, n) ≈ 0.7281209 rtol=1e-4
            @test get_n(IndependentSamplesTTest(two_tails); es, alpha, power) ≈ 104.9279 rtol=1e-6

            @test get_power(IndependentSamplesTTest(two_tails); es = 0.0, alpha, n) ≈ alpha
        end
        @testset "one_tail" begin
            # R gives a warning that full precision might not have been achieved
            @test get_alpha(IndependentSamplesTTest(one_tail); es, power, n) ≈ 0.197544 rtol=1e-3
            @test get_power(IndependentSamplesTTest(one_tail); es, alpha, n) ≈ 0.7989362 rtol=1e-6
            @test get_es(IndependentSamplesTTest(one_tail); alpha, power, n) ≈ 0.6625412 rtol=1e-6
            @test get_n(IndependentSamplesTTest(one_tail); es, alpha, power) ≈ 87.2626 rtol=1e-6
        end
    end

    # Same as the one sample t-test.
    @test get_alpha(DependentSamplesTTest(two_tails); es, power, n) ≈ 0.067 atol=0.01

    n_predictors = 8
    # Beware that G*Power assumes input to be f² and not f.
    @test get_alpha(DeviationFromZeroMultipleRegression(n_predictors); es=sqrt(es), power, n) ≈ 0.072 atol=0.1
    n_tested_predictors = 6
    @test get_alpha(IncreaseMultipleRegression(n_predictors, n_tested_predictors); es=sqrt(es), power, n) ≈ 0.043 atol=0.1
    n_groups = 2
    @test get_alpha(OneWayANOVA(n_groups); es, power, n) ≈ 0.067 atol=0.001
    df = 10
    @test get_alpha(MultifactorFixedEffectsANOVA(n_groups, df); es, power, n) ≈ 0.461 atol=0.01

    n_variables = 2
    @test get_alpha(ConstantVectorHotellingTsqTest(n_variables); es, power, n) ≈ 0.132 atol=0.001
    @test get_alpha(TwoVectorsHotellingTsqTest(n_variables); es, power, n=N) ≈ 0.511 atol=0.001

    df = 5
    @test get_power(GoodnessOfFitChisqTest(df); es, alpha, n) ≈ 0.787 atol=0.001
    @test get_alpha(GoodnessOfFitChisqTest(df); es, power, n) ≈ 0.253 atol=0.001
    @test get_es(GoodnessOfFitChisqTest(df); alpha, power, n) ≈ 0.629 atol=0.001
    @test get_n(GoodnessOfFitChisqTest(df); alpha, power, es) ≈ 79.12 atol=0.001

    # https://github.com/rikhuijzer/PowerAnalyses.jl/issues/21.
    @test get_n(GoodnessOfFitChisqTest(3); alpha=0.05, power=0.80, es=0.10) ≈ 1090.25 atol=0.1

    @test get_alpha(ConstantVarianceChisqTest(one_tail); es, power, n) ≈ 0.038 atol=0.02

    # TODO: Add test for PointBiseralTTest
end
