"""
    Tail

Tail used in some of the tests.
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

See the G*Power 3 paper for many parameters and noncentrality parameters
(https://doi.org/10.3758/BF03193146).

The huge collection of types isn't making this code very pretty.
Unfortunately, it seems to be a requirement when working in the frequentist world.
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
    PointBiserialTTest(tail::Tail) <: TTest

Test a difference between a continous and binary variable for the null hypothesis that the effect size is 0.
"""
struct PointBiserialTTest <: TTest
    tail::Tail
end

"""
    FTest <: StatisticalTest

Tests for the ratio between two variances.
Mostly known for linear regressions such as ANOVAs, MANOVAs and ANCOVAs.
"""
abstract type FTest <: StatisticalTest end

"""
    DeviationFromZeroMultipleRegression(n_predictors::Int) <: FTest

Deviation of R² from zero for multiple regression with `n_predictors`.
Combined with this test, the sample size `n` means the **total** sample size.
"""
struct DeviationFromZeroMultipleRegression <: FTest
    n_predictors::Int
end

"""
    IncreaseMultipleRegression(n_predictors::Int, n_tested_predictors::Int) <: FTest

Increase of R² for multiple regression with total number of predictors `n_predictors` and number of tested predictors `n_tested_predictors`.
"""
struct IncreaseMultipleRegression <: FTest
    n_predictors::Int
    n_tested_predictors::Int
end

"""
    OneWayANOVA(n_groups::Int) <: FTest

Test whether multiple means are equal.
Also known as a one-way fixed effects ANOVA.
"""
struct OneWayANOVA <: FTest
    n_groups::Int
end

"""
    MultifactorFixedEffectsANOVA(n_groups::Int, df::Int) <: FTest

Fixed effects, multifactor and planned comparisons ANOVA with `n_groups` total groups in the design and `df` degrees of freedom in the tested effect.
"""
struct MultifactorFixedEffectsANOVA <: FTest
    n_groups::Int
    df::Int
end

"""
    ConstantVectorHotellingTsqTest(n_response_variables::Int) <: FTest

Hotelling's T-square ``T^2`` to test whether a vector of means differ from a constant mean vector.
"""
struct ConstantVectorHotellingTsqTest <: FTest
    n_response_variables::Int
end

"""
    TwoVectorsHotellingTsqTest(n_response_variables::Int) <: FTest

Hotelling's T-square ``T^2`` to test whether two mean vectors differ.
"""
struct TwoVectorsHotellingTsqTest <: FTest
    n_response_variables::Int
end

"""
    ChisqTest <: StatisticalTest

Supertype for Chi-Square tests.
"""
abstract type ChisqTest <: StatisticalTest end

"""
    GoodnessOfFitChisqTest(df::Int) <: ChisqTest

Chi-square goodness of fit test for categorical variables with more than two levels.
Here, the degrees of freedom `df` are `n_groups - 1`.
"""
struct GoodnessOfFitChisqTest <: ChisqTest
    df::Int
end

"""
    ConstantVarianceChisqTest(tail::Tail) <: ChisqTest

Chi-square test for determining whether the population variance σ² equals a specific (constant) value.
The effect size is the variance `ratio` and defined as `ratio = σ² / c`.

!!! warn
    The result of this test is slightly different from G*Power 3.1.9.7 even though the code here is based on the paper.
    It could be that G*Power 3 has a different calculation for distribution scaling.
"""
struct ConstantVarianceChisqTest <: ChisqTest
    tail::Tail
end

