# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres
to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


## [Unreleased]

### Added

* New function to make a ws crunchable
* Shiny app to compare WS with button to export table
* New WS example and code to generate it

### Changed

* Rename `affect_XXX` functions in `assign_XXX` functions
* Rename `cjo` to `td` in functions name (`assign_cjo`, `export_cjo`, `retrieve_cjo`, `import_cjo`, ) and argument (`cjo` -> `td`)
* The `assign_XXX` and `retrieve_XXX` functions are using `jws` instead of the `ws_path`.
* `select_regs` takes a new argument `context` to define the different regressors sets to use.

### Fixed

* Bug in select regressors solved


## [1.0.0] - 2025-08-29

### Added

* New function to choose calendar regressors adapted to series
* New function to create calendar regressors, french calendar, specification with regressors

[Unreleased]: https://github.com/TanguyBarthelemy/rjd3production/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/TanguyBarthelemy/rjd3production/releases/tag/v1.0.0
