require_relative 'boot'

require 'rails/all'

SETTINGS = YAML.safe_load(File.read(File.expand_path('settings.yml', __dir__)))
SETTINGS.merge! SETTINGS.fetch(Rails.env, {})
SETTINGS.symbolize_keys!

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OhanaWebSearch
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.generators do |g|
      g.test_framework :rspec
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Tell Internet Explorer to use compatibility mode.
    # 'edge' mode tells Internet Explorer to display content in the highest mode available.
    # 'chrome' mode is for when Internet Explorer has the Google Chrome Frame plug-in installed.
    # Note that Google Chrome Frame was retired in Jan. 2014, so this is only for legacy systems.
    # More info at http://blog.chromium.org/2013/06/retiring-chrome-frame.html
    config.action_dispatch.default_headers = { 'X-UA-Compatible' => 'IE=edge,chrome=1' }
  end
end
