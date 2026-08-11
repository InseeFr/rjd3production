# Selection des régresseurs de calendriers

``` r

library("rjd3production")
```

### Sélection des régresseurs

Pour sélectionner un jeu de régresseurs de calendrier, on utilise la
fonction
[`select_td()`](https://inseefr.github.io/rjd3production/reference/select_td.md)
:

``` r

library("rjd3toolkit")
#> 
#> Attaching package: 'rjd3toolkit'
#> The following objects are masked from 'package:stats':
#> 
#>     aggregate, mad
td_table <- select_td(ABS[, seq_len(3L)])
#> 
#> Série X0.2.09.10.M en cours... 1/3 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG2 ...Done !
#> Computing spec REG3 ...Done !
#> Computing spec REG5 ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec LY ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG2_LY ...Done !
#> Computing spec REG3_LY ...Done !
#> Computing spec REG5_LY ...Done !
#> Computing spec REG6_LY ...Done !
#> 
#> Série X0.2.08.10.M en cours... 2/3 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG2 ...Done !
#> Computing spec REG3 ...Done !
#> Computing spec REG5 ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec LY ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG2_LY ...Done !
#> Computing spec REG3_LY ...Done !
#> Computing spec REG5_LY ...Done !
#> Computing spec REG6_LY ...Done !
#> 
#> Série X0.2.07.10.M en cours... 3/3 
#> Computing spec No_TD ...Done !
#> Computing spec REG1 ...Done !
#> Computing spec REG2 ...Done !
#> Computing spec REG3 ...Done !
#> Computing spec REG5 ...Done !
#> Computing spec REG6 ...Done !
#> Computing spec LY ...Done !
#> Computing spec REG1_LY ...Done !
#> Computing spec REG2_LY ...Done !
#> Computing spec REG3_LY ...Done !
#> Computing spec REG5_LY ...Done !
#> Computing spec REG6_LY ...Done !
print(td_table)
#>         series regs
#> 1 X0.2.09.10.M REG6
#> 2 X0.2.08.10.M REG6
#> 3 X0.2.07.10.M REG6
```

### Import / Export

Une fois les régresseurs sélectionnées, vous pouvez exporter le tableau
au format `.yaml` et le réimporter ultérieurement :

``` r

path_td <- tempfile(pattern = "td-table", fileext = ".yaml")
export_td(td_table, path_td)
#> The td table will be written at  /tmp/Rtmpl83dt0/td-table23b75121e8e3.yaml
td_table2 <- import_td(path = path_td)
#> The td table will be read at  /tmp/Rtmpl83dt0/td-table23b75121e8e3.yaml
waldo::compare(td_table, td_table2)
#> ✔ No differences
```

### Assignation

Enfin, pour affecter des régresseurs de calendrier à un workspace, vous
pouvez utiliser la fonction
[`assign_td()`](https://inseefr.github.io/rjd3production/reference/regression_tools.md)
:

``` r

library("rjd3workspace")
my_ws <- jws_open("my_workspace")
assign_td(td_table, my_ws)
```

### Sélection avancée

Par défaut, les régresseurs proposés sont ceux utilisés par l’INSEE (et
dans le SSP). Pour utiliser des ensembles de régresseurs personnalisés,
il suffit de créer un [modelling
context](https://rjdverse.github.io/rjd3toolkit/reference/modelling_context.html)
contenant autant de variables qu’il y a de jeux de régresseurs et un jeu
de régresseurs par variable.

Par exemple, pour les jeux de régresseurs de l’INSEE, voici la structure
du modelling context correspondant :

``` r


str(create_insee_context(), max.level = 2L)
#> List of 2
#>  $ calendars:List of 1
#>   ..$ FR:List of 2
#>   .. ..- attr(*, "class")= chr [1:2] "JD3_CALENDAR" "JD3_CALENDARDEFINITION"
#>  $ variables:List of 11
#>   ..$ REG1   :List of 1
#>   ..$ REG2   :List of 2
#>   ..$ REG3   :List of 3
#>   ..$ REG5   :List of 5
#>   ..$ REG6   :List of 6
#>   ..$ LY     :List of 1
#>   ..$ REG1_LY:List of 2
#>   ..$ REG2_LY:List of 3
#>   ..$ REG3_LY:List of 4
#>   ..$ REG5_LY:List of 6
#>   ..$ REG6_LY:List of 7
```

Imaginons que je souhaite tester uniquement trois types d’ensembles :

- un premier ensemble de régresseurs (`TD2_TB`) contenant deux
  régresseurs : le jeudi, la semaine (et le week-end en contraste)
- un deuxième ensemble (`TD3_TB`) contenant trois régresseurs : jeudi,
  semaine (et week-end en contraste) et le régresseur leap-year
- un troisième ensemble (`TD6_TB`) qui distingue tous les jours de la
  semaine

Nous créons ensuite nos jeux de régresseurs et définissons le modelling
context :

``` r

series_example <- ABS[, 1L]

TD2_TB <- calendar_td(
    s = series_example,
    groups = c(1L, 1L, 1L, 2L, 1L, 0L, 0L)
)

TD3_TB <- cbind(
    calendar_td(
        s = series_example,
        groups = c(1L, 1L, 1L, 2L, 1L, 0L, 0L)
    ),
    lp_variable(s = series_example)
)
colnames(TD3_TB) <- c("group_1", "group_2", "ly")

TD6_TB <- calendar_td(
    s = series_example,
    groups = c(1L, 2L, 3L, 4L, 5L, 6L, 0L)
)

my_regressors_sets <- list(
    TD2_TB = TD2_TB,
    TD3_TB = TD3_TB,
    TD6_TB = TD6_TB
)
my_context <- modelling_context(variables = my_regressors_sets)
```

Nous pouvons désormais utiliser notre contexte pour sélectionner les
régresseurs de calendrier pour chaque séries :

``` r

my_td_table <- select_td(ABS[, seq_len(3L)], context = my_context)
#> 
#> Série X0.2.09.10.M en cours... 1/3 
#> Computing spec No_TD ...Done !
#> Computing spec TD2_TB ...Done !
#> Computing spec TD3_TB ...Done !
#> Computing spec TD6_TB ...Done !
#> 
#> Série X0.2.08.10.M en cours... 2/3 
#> Computing spec No_TD ...Done !
#> Computing spec TD2_TB ...Done !
#> Computing spec TD3_TB ...Done !
#> Computing spec TD6_TB ...Done !
#> 
#> Série X0.2.07.10.M en cours... 3/3 
#> Computing spec No_TD ...Done !
#> Computing spec TD2_TB ...Done !
#> Computing spec TD3_TB ...Done !
#> Computing spec TD6_TB ...Done !
print(my_td_table)
#>         series   regs
#> 1 X0.2.09.10.M TD6_TB
#> 2 X0.2.08.10.M TD6_TB
#> 3 X0.2.07.10.M TD6_TB
```
