"""
    Tail

Tail used in the test.
Can be `one_tail` or `two_tails`.
"""
@enum Tail one_tail two_tails

"""
    StatisticalTest

This package defines its own types which are mostly a subtype of `StatisticalTest`.

There are multiple reasons why the types from `HypothesisTests.jl` weren't re-used:
1. The API design is a bit weird.
    For example, there is no way to pass a tail to a t-test, so it will always print the default tail.
    Also, a paired t-test is hidden under `OneSampleTTest` even though it can have two samples.
    Only when using `pvalue(..., tail)`, the tail is taken into consideration.
1. Adding `HypothesisTests.jl` would also add multiple dependencies which this package doesn't need.
1. It wouldn't be too hard to write a separate wrapper around `HypothesisTests.jl`.
    It only needs to wrap one way.
"""
abstract type StatisticalTest end
abstract type TTest <: StatisticalTest end

"""
    OneSampleTTest <: TTest

Test whether the sample differs from a constant.
"""
struct OneSampleTTest <: TTest
    tail::Tail
end

"""
    UnpairedTTest <: TTest

Test a difference between two independent groups.
Also known as a _independent means t-test_, _independent samples t-test_.
"""
struct UnpairedTTest <: TTest end

"""
    PairedTTest <: TTest

Test a difference between pairs of values.
Also known as a _correlated pairs t-test_, _dependent samples t-test_ or _dependent means t-test_.
"""
struct PairedTTest <: TTest end
