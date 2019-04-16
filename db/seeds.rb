# This file should contain all the record creation needed to seed the database
# with its default values. The data can then be loaded with `rake db:seed`
# (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) are set in the file config/application.yml.
# See http://railsapps.github.com/rails-environment-variables.html
User.find_or_create_by(email: 'admin@example.com') do |u|
  u.first_name = 'Admin'
  u.last_name = 'User'
  u.password = 'password'
  u.password_confirmation = 'password'
  u.admin = true
end
