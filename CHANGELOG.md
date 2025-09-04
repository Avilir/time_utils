# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2025-09-04

### Added
- Initial release of ALT-time-utils package
- Core time utility functions:
  - `get_utc_timestamp()` - Get current UTC timestamp
  - `get_utc_timestamp_string()` - Get UTC timestamp as ISO string with 'Z' suffix
  - `get_local_timestamp()` - Get current local timestamp
  - `local_to_utc()` - Convert local datetime to UTC
  - `utc_to_local()` - Convert UTC datetime to local
  - `get_local_timezone_name()` - Get local timezone name
  - `format_utc_timestamp()` - Format any datetime as UTC ISO string
  - `get_local_utc_offset()` - Get local UTC offset
  - `get_file_timestamp()` - Get timestamp for filenames (YYYYMMDD_HHMMSS)
  - `get_date_string()` - Get date string (YYYYMMDD)
  - `get_time_string()` - Get time string (HHMMSS)
  - `format_duration()` - Format duration in human-readable format
- Full type hints for all functions
- Comprehensive test suite with 100% coverage
- Support for Python 3.8+
- Development scripts (setup, test, build)
- Makefile for common tasks
- Pre-commit hooks configuration
- MIT License

[Unreleased]: https://github.com/Avilir/time_utils/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/Avilir/time_utils/releases/tag/v0.1.0
