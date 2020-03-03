module EventsHelper
  def datetime_formater(date_time)
    date_format = '%d.%m.%Y'
    DateTime.strptime(date_time, date_format)
  rescue => e
    raise DateFormatError
  end

  def cache_key_for_events
    filters = []
    latest_updated_at = @events.order(updated_at: :desc).select(:updated_at).first&.updated_at&.to_f
    filters << @date_filter
    filters << @extract_filter
    filters << @query
    filters << latest_updated_at
    return "events/index-#{filters.join('-')}"
  end
end


class DateFormatError < StandardError
  def message
    'Date format invalid'
  end
end
