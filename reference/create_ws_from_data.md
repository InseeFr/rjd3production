# Create a Workspace from Data

Creates a new JDemetra+ workspace with all columns of a time series
object using a specified specification.

Each column of `x` is interpreted as a separate time series and added to
a newly created Seasonal Adjustment Processing (SAP).

## Usage

``` r
create_ws_from_data(x, spec = rjd3x13::x13_spec())
```

## Arguments

- x:

  A time series object (e.g. `ts`, `mts`, or matrix coercible to `ts`)
  where each column represents a series to be seasonally adjusted.
  Column names are used as SA-Item names.

- spec:

  A JDemetra+ specification. Defaults to
  [`rjd3x13::x13_spec()`](https://rjdverse.github.io/rjd3x13/reference/x13_spec.html).

## Value

A JDemetra+ workspace object (Java pointer) containing one SA-Processing
with one SA-Item per column of `x`.

## Details

All series share the same specification (`spec`).

## Examples

``` r
data(AirPassengers)

# Create a multivariate time series
x <- cbind(
  series1 = AirPassengers,
  series2 = log(AirPassengers)
)

# Create workspace
ws <- create_ws_from_data(x)
```
