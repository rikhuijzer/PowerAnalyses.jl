# PowerAnalyses.jl

[![CI Test][ci-img]][ci-url]
[![Documentation][docs-dev-img]][docs-dev-url]

Statistical power analyses

## Introduction

Statistical power is the probability that a test will correctly indicate an effect when there is one.
In other words, it is the inverse of making a Type II error (false negative) β: `power = 1 - β`.

The priorities of this package are as follows:

1. make it easy for anyone to run a power analysis; even for people who never used the Julia programming language before and
1. don't overuse Unicode symbols (it is unreasonable to expect that everyone can easily type Unicode)

See <https://rikhuijzer.github.io/PowerAnalyses.jl/dev/> for more information.

[ci-img]: https://github.com/rikhuijzer/PowerAnalyses.jl/workflows/CI/badge.svg
[ci-url]: https://github.com/rikhuijzer/PowerAnalyses.jl/actions?query=workflow%3ACI+branch%3Amain
[docs-dev-img]: https://img.shields.io/badge/Docs-dev-blue.svg
[docs-dev-url]: https://rikhuijzer.github.io/PowerAnalyses.jl/dev/
