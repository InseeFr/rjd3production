# Random JDemetra+ Specifications Generator

`random_spec()` allows you to create a random specification based on a
set of helper functions (auxiliary functions). These specifications are
created from scratch.

## Usage

``` r
random_spec()
```

## Value

a JD+ Specification

## Details

The objective is to enable:

- examples

- tests of other functions (notably for reverse engineering)

- other tests and demonstrations

## Examples

``` r
set.seed(1L)
spec <- random_spec()
```
