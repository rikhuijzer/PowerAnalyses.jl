module PowerAnalyses

using Distributions:
    NoncentralT,
    TDist,
    UnivariateDistribution,
    ccdf,
    cdf,
    pdf,
    quantile
using Roots:
    find_zero

const PKGDIR = string(pkgdir(PowerAnalyses))::String

let
    path = joinpath(PKGDIR, "README.md")
    text = read(path, String)
    @doc text PowerAnalyses
end

const PARAMS = [:es, :alpha, :power, :n]

include("types.jl")
include("power.jl")

export one_tail, two_tails
export OneSampleTTest, UnpairedTTest, PairedTTest
export calculate

end # module
