# Changelog
All notable changes to priv-all-portal-docs will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Develop]

### Added

### Changed

### Removed

### Fixed

## [2.2.1] - 2019-03-28

### Fixed

- Patroni had a bug that resulted in redundant \<h1> elements on all but the index page. This is now being parsed out by the common.py script.
  
- Patroni also had a bug where a blank "Search" page was being generated along with the rest of the documentation - removed.

## [2.2.0] - 2019-02-23

### Added

- Crunchy PostgreSQL for PCF documentation project is added

- Older versions of Crunchy Container Suite and PostgreSQL Operator documentation are now supported

### Changed

- Menu shortcuts can be opened in a new tab

- pgstigcheck-inspec was adjusted to account for the updated source documentation

### Fixed

- Images now correctly referenced for pgMonitor

- pgBackRest docs >= 2.08 now create doc source using Perl script
