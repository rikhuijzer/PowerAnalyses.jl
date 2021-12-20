# PowerAnalyses.jl

[![CI Test][ci-img]][ci-url]
[![Documentation][docs-img]][docs-url]

Statistical power analyses

## Installation

```julia
pkg> add PowerAnalyses
```

## Introduction

Statistical power is the probability that a test will correctly indicate an effect when there is one.
In other words, it is the inverse of making a Type II error (false negative) β: `power = 1 - β`.

The priorities of this package are as follows:

1. make it easy for anyone to run a power analysis; even for people who never used the Julia programming language before and
1. don't overuse Unicode symbols (it is unreasonable to expect that everyone can easily type Unicode)

See <https://rikhuijzer.github.io/PowerAnalyses.jl/stable/> for more information.

[ci-img]: https://github.com/rikhuijzer/PowerAnalyses.jl/workflows/CI/badge.svg
[ci-url]: https://github.com/rikhuijzer/PowerAnalyses.jl/actions?query=workflow%3ACI+branch%3Amain

[docs-img]: https://img.shields.io/badge/Docs-stable-blue.svg
[docs-url]: https://rikhuijzer.github.io/PowerAnalyses.jl/stable/

## Validity

For each test in this package, the result provided by this package is verified by comparing it to either `G*Power` or `pwr` see `test/runtests.jl` for details.

## Usage

The package defines `get_alpha`, `get_power`, `get_es` and `get_n`.
For example, to get the required sample size `n`  for an effect size `es` of 0.5, `power` of 0.95 and significance level `alpha` of 0.05 for a one sample *t*-test use:

```julia
julia> using PowerAnalyses

julia> es = 0.5
0.5

julia> alpha = 0.05
0.05

julia> power = 0.95
0.95

julia> n = get_n(OneSampleTTest(two_tails); alpha, power, es)
53.941
```

This number is the same as what you would get via G\*Power.

For fun. We can now try to get the original alpha back by passing `n` to `get_alpha`:

```julia
julia> get_alpha(OneSampleTTest(two_tails); power, n, es)
0.049999999999997824
```

Close enough.
