# PowerAnalyses

Statistical power analyses.

## Getting started


This package allows you to determine one of the following parameters:

- sample size `n`
- `power`
- significance level `alpha`
- effect size `es`

when knowing the other three parameters.

For example, to calculate the required sample size for a two tailed t-test, we can use the `OneSampleTTest` type:

```@example
using PowerAnalyses

es = 0.5
alpha = 0.05
power = 0.95

T = OneSampleTTest(two_tails)
get_n(T; alpha, power, es)
```

## Functions

The functions for determining the parameters take the following arguments:

```@docs
get_power
get_alpha
get_es
get_n
```

## Tests

```@eval
# Don't try to be clever here and generate @ref links.
# Documenter.jl will not parse them as Markdown or whatever.
# Evaluation appears to be happening very late in the process.
```

The following tests are implemented:

```@autodocs
Modules = [PowerAnalyses]
Private = false
Order = [:type]
```
