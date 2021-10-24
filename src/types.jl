"""
    Tail

Tail used in the test.
Can be `one_tail` or `two_tails`.
"""
@enum Tail one_tail two_tails

"""
    StatisticalTest

Supertype for all test types in this package.

The lowest level types are all structs because some of them need to hold values.
A parameter can become a struct field when it's never required to infer the parameter from the other parameters.
For example, it doesn't make sense to use a power analysis to check whether one should use a one tailed or two tailed t-test.
As another example, it does make sense to use a power analysis to check the required sample size `n` (an a priori power analysis).
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
    IndependentSamplesTTest(tail::Tail) <: TTest

Test a difference between two independent groups.
When using this type, make sure that `n` states the total number of samples in both groups.
Also known as a _independent means t-test_ or _independent samples t-test_.


!!! note
    foo bar
"""
struct IndependentSamplesTTest <: TTest
    tail::Tail
end

"""
    DependentSamplesTTest(tail::Tail) <: TTest

Test a difference between pairs of values.
Also known as a _correlated pairs t-test_, _dependent samples t-test_ or _dependent means t-test_.
"""
struct DependentSamplesTTest <: TTest
    tail::Tail
end

"""
    FTest <: StatisticalTest

Tests for the ratio between two variances.
Mostly known for linear regressions such as ANOVAs, MANOVAs and ANCOVAs.

!!! warning
    There are lots of discussions about calculating the power for these kinds of tests.
    For example, see https://stats.stackexchange.com/questions/59235.
"""
abstract type FTest <: StatisticalTest end

struct ANOVATest <: FTest
    n_groups::Int
end

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
