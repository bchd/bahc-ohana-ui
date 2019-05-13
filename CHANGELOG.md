# Change Log

## [?.?.?] - 2019-05-10
### ahc-sprint-23
### Added
  - AHC-1354
    - Added title attribute to filter labels to show full category names
  - AHC-1370
    - Show the situation categories grouped on the service
  - AHC-1421
    - Adds a free-text field to name the organization a user is affiliated with
### Changed
  - AHC-1413
    - Sort the service categories prior to listing them out on a service
  - AHC-1262
    - Update style on global header
  - AHC-1263
    - Update style on global footer
  - AHC-1261
    - Update style on landing page search box
    - Update fonts everywhere
  - AHC-1265
    - Update style on search results page sidebar
    
## [?.?.?] - 2019-04-26
### ahc-sprint-22
### Added
  - AHC-1410
    - Commit BHCD and CHARMcare logos and icons to assets
    - Set CHARMcare logo and favicon in UI
  - AHC-1301
    - Show the wait time in the search results if logged in
  - AHC-1259
    - Change the front page to allow searching near a location
  - AHC-1215
    - This fleshes out the user profile/management pages for both regular and admin users. In particular:
      - `Sign up` when not logged in provides instructions on how to request an account
      - `Forgot Password` goes to a page that takes your email and emails you a link to reset your password
      - Upon login, a normal user has two options: `Edit Profile` or `Sign Out`
        - `Edit Profile allows a user to change their first/last name or password.
      - Upon login, an admin user has four options: `Edit Profile`, `Add User`, `User List`, or `Sign Out`
        - `Edit Profile` allows an admin to change their first/last name, email, password, or admin status.
        - `Add User` allows an admin to add a new user/admin given first/last names and email address. Upon registering the new user, that user is emailed with a link to set their password.
        - `User List` lists all users by last name, then first name.
          - `Delete User` immediately deletes that user (need a story to add a confirmation!)
          - `Edit User` allows the admin to edit that user's name/email/admin status
  - AHC-1075
    - Added capability to filter by service categories in the search sidebar.
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

