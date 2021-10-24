"""
    Tail

Tail used in the test.
Can be `one_tail` or `two_tails`.
"""
@enum Tail one_tail two_tails

"""
    StatisticalTest

Supertype for all test types in this package.

!!! note
    This package defines its own types.
    There are multiple reasons why the types from `HypothesisTests.jl` weren't re-used:
    1. The API design is a bit weird.
        For example, there is no way to pass a tail to a t-test, so it will always print the default tail.
        Only when using `pvalue(..., tail)`, the tail is taken into consideration.
    1. Adding `HypothesisTests.jl` would also add multiple dependencies which this package doesn't need.
    1. It wouldn't be too hard to write a separate wrapper around `HypothesisTests.jl`.
        Since a priori tests make the most sense, there is only a need to allow converting a power analysis to a test.
"""
abstract type StatisticalTest end

"""
    TTest <: StatisticalTest

Tests based around the Student's t-distribution.
"""
abstract type TTest <: StatisticalTest end

"""
    OneSampleTTest(tail::Tail) <: TTest

Test whether the sample differs from a constant.
"""
struct OneSampleTTest <: TTest
    tail::Tail
end

"""
    IndependentSamplesTTest <: TTest

Test a difference between two independent groups.
Also known as a _independent means t-test_ or _independent samples t-test_.
"""
struct UnpairedTTest <: TTest end

"""
    DependentSamplesTTest <: TTest

Test a difference between pairs of values.
Also known as a _correlated pairs t-test_, _dependent samples t-test_ or _dependent means t-test_.
"""
struct PairedTTest <: TTest end

"""
    FTest <: StatisticalTest

Tests for the ratio between two variances.
Mostly known for linear regressions such as ANOVAs, MANOVAs and ANCOVAs.

!!! note
    There is a lot of discussion about these kinds of tests:
    https://stats.stackexchange.com/questions/59235.
    So, it has lower priority to implement for now.
"""
abstract type FTest <: StatisticalTest end

"""
    ChiSqTest <: StatisticalTest

Supertype for Chi-Square tests.
"""
abstract type ChiSqTest <: StatisticalTest end

"""
    GoodnessOfFitChiSqTest(df::Int) <: ChiSqTest

Chi-Square goodness of fit test for categorical variables with more than two levels.
Here, the degrees of freedom `df` are `n_groups - 1`.
"""
struct GoodnessOfFitChiSqTest <: ChiSqTest
    df::Int
end
