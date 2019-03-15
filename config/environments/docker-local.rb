Rails.application.configure do
    # Same Settings as development
    require Rails.root.join('config', 'environments', 'develop')

    # Raises error for missing translations
    config.action_view.raise_on_missing_translations = true

    config.log_formatter = ::Logger::Formatter.new
  if ENV['RAILS_LOG_TO_STDOUT'] == 'true'
    logger = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end
end
  