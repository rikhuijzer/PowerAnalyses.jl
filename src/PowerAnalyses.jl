module PowerAnalyses

using Distributions:
    NoncentralChisq,
    NoncentralF,
    NoncentralT,
    UnivariateDistribution,
    cdf,
    quantile
using Roots: find_zero

include("types.jl")
include("power.jl")

export Tail, one_tail, two_tails

export IndependentSamplesTTest
export DependentSamplesTTest
export OneSampleTTest

export DeviationFromZeroMultipleRegression
export IncreaseMultipleRegression
export OneWayANOVA
export MultifactorFixedEffectsANOVA
export ConstantVectorHotellingTsqTest
export TwoVectorsHotellingTsqTest

export GoodnessOfFitChisqTest
export ConstantVarianceChisqTest

export get_alpha, get_power, get_es, get_n

end # module
