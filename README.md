# PowerAnalyses.jl

Statistical power analyses

## Introduction

Statistical power is the probability that a test will correctly indicate an effect when there is one.
In other words, it is the inverse of making a Type II error (false negative) β: `power = 1 - β`.

The priorities of this package are as follows:

1. make it easy for anyone to run a power analysis; even for people who never used the Julia programming language before,
1. don't overuse Unicode symbols (it is unreasonable to expect that everyone can easily type Unicode), and
1. focus on supporting power analyses which are conducted before running statistical tests (also known as a _prospective_ or _a priori_ power analysis)[^post],

[^post]: Post hoc analysis of nonsignificant results are advised against (Ellis, [2015](https://doi.org/10.1017/CBO9780511761676)).
