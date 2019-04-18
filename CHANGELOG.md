# Change Log

## [?.?.?] - 2019-04-26
### ahc-sprint-22
### Added
  - AHC-1075
    - Added capability to filter by service categories in the search sidebar.

## [?.?.?] - 2019-03-08
### ahc-sprint-19
### Added
 - AHC-1068
    - Updated the app to use the rails, as opposed to just a subset of rails gems
    - Added database configuration and `pg` gem for PostgreSQL integration
    - Added devise gem and created a User model for authentication
    - Included an `admin` flag on the user to designate them as a user
    - Hide the `Service Wait Estimate` unless user is logged in.
    - Only allow admins to create new accounts.

