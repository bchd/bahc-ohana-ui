module WaitTimeHelper
  # rubocop:disable Metrics/MethodLength
  def wait_time_icon_classes(service)
    case service&.wait_time
    when 'Available Today'
      'fa fa-check-circle-o available'
    when 'Next Day Service'
      'fa fa-chevron-circle-right next-day'
    when '2-3 Day Wait'
      'fa fa-clock-o short-wait'
    when '1 Week Wait'
      'fa fa-times-circle-o long-wait'
    else
      'fa fa-question-circle-o unknown'
    end
  end
  # rubocop:enable Metrics/MethodLength
end
