# Package index

## Initialisation

Functions to create object with default Insee information

- [`init_env()`](https://inseefr.github.io/rjd3production/reference/init_env.md)
  : Initialize a seasonal adjustment project environment

## Creation

Functions to create object with default Insee information

- [`create_french_calendar()`](https://inseefr.github.io/rjd3production/reference/insee_modelling.md)
  [`create_insee_regressors()`](https://inseefr.github.io/rjd3production/reference/insee_modelling.md)
  [`create_insee_regressors_sets()`](https://inseefr.github.io/rjd3production/reference/insee_modelling.md)
  [`create_insee_context()`](https://inseefr.github.io/rjd3production/reference/insee_modelling.md)
  : French modelling context, calendar and trading days regressors.
- [`create_specs_set()`](https://inseefr.github.io/rjd3production/reference/create_specs_set.md)
  : Creating a set of X13 specifications
- [`create_ws_from_data()`](https://inseefr.github.io/rjd3production/reference/create_ws_from_data.md)
  : Create a Workspace from Data

## Comparison

Compare different WS

- [`compare()`](https://inseefr.github.io/rjd3production/reference/compare.md)
  : Compare series across workspaces
- [`run_app()`](https://inseefr.github.io/rjd3production/reference/run_app.md)
  : Run the Shiny comparison app

## Retrieve information

Get information from a whole WS and identify by name

- [`get_jsai_by_name()`](https://inseefr.github.io/rjd3production/reference/get_jsai_by_name.md)
  : Retrieve a SA-Item by its name
- [`get_named_variables()`](https://inseefr.github.io/rjd3production/reference/get_named_variables.md)
  : Retrieve all the auxiliary variables from a workspace
- [`get_series()`](https://inseefr.github.io/rjd3production/reference/get_series.md)
  : Extract all series from a SA-Item

## Modify WS

Modification of a WS with applying a property to each SAP and SAI

- [`add_raw_data_path()`](https://inseefr.github.io/rjd3production/reference/add_raw_data_path.md)
  : Add raw data from a file to a JWS workspace
- [`remove_non_significant_outliers()`](https://inseefr.github.io/rjd3production/reference/remove_non_significant_outliers.md)
  : Remove non-significant outliers from a JDemetra+ workspace
- [`set_minimum_span()`](https://inseefr.github.io/rjd3production/reference/set_minimum_span.md)
  : Set span minimum to a value
- [`make_ws_crunchable()`](https://inseefr.github.io/rjd3production/reference/make_ws_crunchable.md)
  : Make a workspace crunchable

## Rev-engineer

Get code from a specification and generate random specifications

- [`rev_spec()`](https://inseefr.github.io/rjd3production/reference/translate-spec.md)
  : Reverse Engineering of rjd3 Specifications
- [`random_spec()`](https://inseefr.github.io/rjd3production/reference/random-spec.md)
  : Random JDemetra+ Specifications Generator

## Global workflow

Function to retrieve regressions information, apply, export and import
it

- [`assign_outliers()`](https://inseefr.github.io/rjd3production/reference/regression_tools.md)
  [`assign_td()`](https://inseefr.github.io/rjd3production/reference/regression_tools.md)
  [`export_outliers()`](https://inseefr.github.io/rjd3production/reference/regression_tools.md)
  [`import_outliers()`](https://inseefr.github.io/rjd3production/reference/regression_tools.md)
  [`export_td()`](https://inseefr.github.io/rjd3production/reference/regression_tools.md)
  [`import_td()`](https://inseefr.github.io/rjd3production/reference/regression_tools.md)
  [`retrieve_outliers()`](https://inseefr.github.io/rjd3production/reference/regression_tools.md)
  [`retrieve_td()`](https://inseefr.github.io/rjd3production/reference/regression_tools.md)
  : Manage regression components in JDemetra+ workspaces
- [`select_td()`](https://inseefr.github.io/rjd3production/reference/select_td.md)
  : Select Calendar Regressors for One or Multiple Series

## Deprecated

Deprecated functions

- [`remove_non_significative_outliers()`](https://inseefr.github.io/rjd3production/reference/deprecated-rjd3production.md)
  : Deprecated functions
