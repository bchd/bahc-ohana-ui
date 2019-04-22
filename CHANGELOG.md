# Change Log

## [?.?.?] - 2019-04-26
### ahc-sprint-22
### Added
  - AHC-1075
    - Added capability to filter by service categories in the search sidebar.
  - AHC-1301
    - Show the wait time in the search results if logged in
### Changed
  - AHC-1311
    - Show the service categories on each individual service

## [?.?.?] - 2019-04-12
### ahc-sprint-21
### Changed
  - AHC-1280
    - Added `Next Day Service` wait time label and icon
    - Changed colors for existing wait time icons

## [?.?.?] - 2019-03-29
### ahc-sprint-20
### Added
  - db:seed now creates default admin user
### Changed
  - AHC-1150
    - Added icons inline with service wait time estimate values, handle unknown wait time

## [?.?.?] - 2019-03-15
### ahc-sprint-19
### Added
 - AHC-1068
    - Updated the app to use the rails, as opposed to just a subset of rails gems
    - Added database configuration and `pg` gem for PostgreSQL integration
    - Added devise gem and created a User model for authentication
    - Included an `admin` flag on the user to designate them as a user
    - Hide the `Service Wait Estimate` unless user is logged in.
    - Only allow admins to create new accounts.

