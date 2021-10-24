module PowerAnalyses

using Distributions:
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

const PARAMS = [:es, :alpha, :power, :n]

include("types.jl")
include("power.jl")

export Tail, one_tail, two_tails
export StatisticalTest
export IndependentSamplesTTest, DependentSamplesTTest, OneSampleTTest
export GoodnessOfFitChiSqTest
export ANOVATest
export get_alpha, get_power, get_es, get_n

end # module
