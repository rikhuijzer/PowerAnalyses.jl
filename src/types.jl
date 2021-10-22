@enum Tail one_tail two_tails

abstract type StatisticalTest end

"""
    OneSampleTTest <: StatisticalTest

Test whether the sample differs from a constant.
"""
struct OneSampleTTest <: StatisticalTest
    tail::Tail
end

"""
    UnpairedTTest <: StatisticalTest

Test a difference between two independent groups.
Also known as a _independent means t-test_, _independent samples t-test_.
"""
struct UnpairedTTest <: StatisticalTest end

"""
    PairedTTest <: StatisticalTest

Test a difference between pairs of values.
Also known as a _correlated pairs t-test_, _dependent samples t-test_ or _dependent means t-test_.
"""
struct PairedTTest <: StatisticalTest end
