# Retrieve all the auxiliary variables from a workspace

Lists all the variables in a modelling context.

## Usage

``` r
get_named_variables(context = NULL)
```

## Arguments

- context:

  a modelling context

## Value

a list with all the groups and named variables

## Examples

``` r
context_FR <- create_insee_context()
get_named_variables(context_FR)
#> $REG1
#> [1] "REG1.REG1"
#> 
#> $REG2
#> [1] "REG2.group_1" "REG2.group_2"
#> 
#> $REG3
#> [1] "REG3.group_1" "REG3.group_2" "REG3.group_3"
#> 
#> $REG5
#> [1] "REG5.group_1" "REG5.group_2" "REG5.group_3" "REG5.group_4" "REG5.group_5"
#> 
#> $REG6
#> [1] "REG6.group_1" "REG6.group_2" "REG6.group_3" "REG6.group_4" "REG6.group_5"
#> [6] "REG6.group_6"
#> 
#> $LY
#> [1] "LY.LY"
#> 
#> $REG1_LY
#> [1] "REG1_LY.LY"   "REG1_LY.REG1"
#> 
#> $REG2_LY
#> [1] "REG2_LY.LY"      "REG2_LY.group_1" "REG2_LY.group_2"
#> 
#> $REG3_LY
#> [1] "REG3_LY.LY"      "REG3_LY.group_1" "REG3_LY.group_2" "REG3_LY.group_3"
#> 
#> $REG5_LY
#> [1] "REG5_LY.LY"      "REG5_LY.group_1" "REG5_LY.group_2" "REG5_LY.group_3"
#> [5] "REG5_LY.group_4" "REG5_LY.group_5"
#> 
#> $REG6_LY
#> [1] "REG6_LY.LY"      "REG6_LY.group_1" "REG6_LY.group_2" "REG6_LY.group_3"
#> [5] "REG6_LY.group_4" "REG6_LY.group_5" "REG6_LY.group_6"
#> 
```
