# PowerAnalyses

Statistical power analyses in Julia.

This package is similar to G\*Power and R's `pwr` package.
Unlike G\*Power, PowerAnalyses is open source and can, therefore, be more easily improved and verified.
Compared to `pwr`, this package contains more analyses and thanks to Julia's multiple dispatch the code of this package is much cleaner, that is, less prone to errors.

## Getting started

This package can be installed via:

```julia
using Pkg

Pkg.add("PowerAnalyses")
```

and allows you to determine one of the following parameters:

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
