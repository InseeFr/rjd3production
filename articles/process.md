# Mise en place d’une chaîne de production

``` r
library("rjd3production")
```

Le package {rjd3production} est utile pour mettre en place une chaîne de
production de séries désaisonnalisées.

Avant de créer notre chaîne de production, il faut créer notre
environnement de travail, notre projet. La fonction
[`init_env()`](https://inseefr.github.io/rjd3production/reference/init_env.md)
créer une structure :

- un dossier `data/` : nos données brutes
- un dossier `Workspaces/` : nos workspaces
- un dossier `output/` : les séries, tableaux et graphiques en sortie
- un dossier `specs/` : les spécifications propres au workspace
  (régresseurs de calendrier, outliers…)
- un dossier `BQ/` : les bilans qualité et fichiers de décisions
- un fichier DESCRIPTION pour gérer les dépendances de notre projet
- un fichier `.lintr` pour faire l’analyse statique du code (bonnes
  pratiques de formattage)
- un fichier README.md pour expliquer notre projet

``` r
path_project <- tempfile(pattern = "my_sa_project")
init_env(path = path_project)
```

Dans cette vignette, nous allons créer une chaîne de production à partir
du jeu de données ABS du package {rjd3toolkit}. Le jeu de données se
trouve aussi sous la forme du fichier `ABS.csv` sous
/home/runner/work/\_temp/Library/rjd3providers/extdata/ABS.csv dans le
package {rjd3providers}.

``` r
library("rjd3toolkit")
path_ABS <- system.file("extdata", "ABS.csv", package = "rjd3providers")
my_data <- ABS[, seq_len(3L)]
colnames(my_data) <- substr(colnames(my_data), start = 2L, stop = 11L)
```

## Sélection des régresseurs de calendrier

Dans le cas où nos séries sont sensibles aux effets de calendrier, on
peut corriger ses effets avec des régresseurs de calendrier.

Pour cela, consulter la vignette `td-selection` au sujet de la manière
de traiter ces effets et comment produire la table `td` contenant nos
régresseurs de calendrier personnalisés selectionnés.

``` r
td <- select_td(my_data)
#> 
#> Série 0.2.09.10. en cours... 1/3 
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
#> Série 0.2.08.10. en cours... 2/3 
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
#> Série 0.2.07.10. en cours... 3/3 
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
```

## Création d’un workspace

Nous utiliserons le package {rjd3workspace} pour les fonctions de
création et manipulation des workspaces.

``` r
library("rjd3workspace")
```

Pour créer un nouveau worspace, vous avez le choix entre le créer à la
main depuis 0 ou à partir d’un jeu de données. Si vous utilisez des
variables externes, des régresseurs de calendrier ou un calendrier
personnalisé, il ne faut pas oublier de mettre tout cela dans un
modelling context.

A l’Insee, nous utilisons la fonction
[`create_insee_context()`](https://inseefr.github.io/rjd3production/reference/insee_modelling.md)
pour nous créer nos context:

``` r
my_context <- create_insee_context(s = my_data[, 1L])
```

Nous utiliserons le package {rjd3x13} pour créer les specs X13.

``` r
library("rjd3x13")
```

- Créer un workspace à partir de 0

``` r
jws <- jws_new(modelling_context = my_context)
jsap <- jws_sap_new(jws, "Nouveau SAP")
add_sa_item(jsap = jsap, name = "Première série", x = my_data[, 1L], spec = x13_spec())
add_sa_item(jsap = jsap, name = "Seconde série", x = my_data[, 2L], spec = x13_spec())
#... avec autant de commande que de séries
```

- Créer un workspace à partir d’un dataset

``` r
jws <- create_ws_from_data(my_data)
set_context(jws, create_insee_context(start = c(2015L, 1L)))
```

Si nous en avons, il faut assigner les régresseurs de calendrier à
chaque série :

``` r
jws_compute(jws)
assign_td(td = td, jws = jws)
#> Série 0.2.09.10., 1/3
#> Série 0.2.08.10., 2/3
#> Série 0.2.07.10., 3/3
```

Il ne faut pas oublier de mettre à jour les metadonnées de notre
workspace avec le chemin vers nos données brutes :

``` r
add_raw_data_path(jws, path_ABS, delimiter = "COMMA")
#> Warning: There are no columns called 0.2.09.10. in ABS.csv
#> Warning: There are no columns called 0.2.08.10. in ABS.csv
#> Warning: There are no columns called 0.2.07.10. in ABS.csv
```

Enfin, nous pouvons sauvegarder notre workspace !

``` r
path_ws <- file.path(path_project, "Workspaces", "workspace_travail", "my_ws.xml")
save_workspace(jws, path_ws, replace = TRUE)
```

## Appel du cruncher

Dans une chaîne de production en R, le cruncher est très important car
il permet de :

1.  Mettre à jour les données brutes à partir du fichier de données
2.  Mettre à jour le modèle d’ajustement saisonnier (selon une politique
    de rafraichissement)
