@enum Tail one_tail two_tails

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
