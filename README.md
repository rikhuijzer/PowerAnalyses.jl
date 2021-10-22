# PowerAnalyses.jl

Statistical power analyses

## Introduction

Statistical power is the probability that a test will correctly indicate an effect when there is one.
In other words, it is the inverse of making a Type II error (false negative) β: `power = 1 - β`.

The priorities of this package are as follows:

1. support power analyses which are conducted before running statistical tests (also known as a _prospective_ or _a priori_ power analysis)[^post], and
1. don't overuse Unicode symbols (it is unreasonable to expect that everyone can easily type Unicode),
1. support the situation where one of the four power parameters has to be determined when knowing three parameters.

The four parameters of a power analysis are:

1. Effect size `es`
1. Alpha level `alpha` (also known as a _Type I error_ or _false positive_)
1. Power `power` (`1 - β`)
1. Sample size `n`

And the available types of tests are:

- *t*-tests
- *F*-tests
- *Χ^2*-tests

since these are the most commonly used (Erdfelder, [1997](https://doi.org/10.3758/BF03203630)).

[^post]: Post hoc analysis of nonsignificant results are wrong (Ellis, [2015](https://doi.org/10.1017/CBO9780511761676)).
