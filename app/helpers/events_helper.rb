module EventsHelper
  def datetime_formater(date_time)
    date_format = '%d.%m.%Y'
    DateTime.strptime(date_time, date_format)
  end

  def cache_key_for_events
    filters = []

    latest_updated_at = Event.only(:updated_at).pluck(:updated_at).max.to_f
    filters << @date_filter
    filters << @extract_filter
    filters << @query
    filters << latest_updated_at
    return "events/index-#{filters.join('-')}"
  end
end
