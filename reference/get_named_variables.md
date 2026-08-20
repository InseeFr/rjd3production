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
#> [1] "REG1.week"
#> 
#> $REG2
#> [1] "REG2.week"     "REG2.saturday"
#> 
#> $REG3
#> [1] "REG3.monday"            "REG3.tuesday_to_friday" "REG3.saturday"         
#> 
#> $REG5
#> [1] "REG5.monday"    "REG5.tuesday"   "REG5.wednesday" "REG5.thursday" 
#> [5] "REG5.friday"   
#> 
#> $REG6
#> [1] "REG6.monday"    "REG6.tuesday"   "REG6.wednesday" "REG6.thursday" 
#> [5] "REG6.friday"    "REG6.saturday" 
#> 
#> $LY
#> [1] "LY.LY"
#> 
#> $REG1_LY
#> [1] "REG1_LY.LY"        "REG1_LY.REG1_week"
#> 
#> $REG2_LY
#> [1] "REG2_LY.LY"       "REG2_LY.week"     "REG2_LY.saturday"
#> 
#> $REG3_LY
#> [1] "REG3_LY.LY"                "REG3_LY.monday"           
#> [3] "REG3_LY.tuesday_to_friday" "REG3_LY.saturday"         
#> 
#> $REG5_LY
#> [1] "REG5_LY.LY"        "REG5_LY.monday"    "REG5_LY.tuesday"  
#> [4] "REG5_LY.wednesday" "REG5_LY.thursday"  "REG5_LY.friday"   
#> 
#> $REG6_LY
#> [1] "REG6_LY.LY"        "REG6_LY.monday"    "REG6_LY.tuesday"  
#> [4] "REG6_LY.wednesday" "REG6_LY.thursday"  "REG6_LY.friday"   
#> [7] "REG6_LY.saturday" 
#> 
```
