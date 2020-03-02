module EventsHelper
  def datetime_formater(date_time)
    date_format = '%d.%m.%Y'
    DateTime.strptime(date_time, date_format)
  end
end
