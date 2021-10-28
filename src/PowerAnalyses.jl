module PowerAnalyses

using Distributions:
    LocationScale,
    NoncentralChisq,
    NoncentralF,
    NoncentralT,
    TDist,
    UnivariateDistribution,
    ccdf,
    cdf,
    pdf,
    quantile
using Roots: find_zero

const PKGDIR = string(pkgdir(PowerAnalyses))::String

let
    path = joinpath(PKGDIR, "README.md")
    text = read(path, String)
    @doc text PowerAnalyses
end

include("types.jl")
include("power.jl")

export Tail, one_tail, two_tails
export IndependentSamplesTTest, DependentSamplesTTest, OneSampleTTest
export OneWayANOVA, ConstantVectorHotellingTsqTest, TwoVectorsHotellingTsqTest
export GoodnessOfFitChisqTest, ConstantVarianceChisqTest
export get_alpha, get_power, get_es, get_n

end # module
