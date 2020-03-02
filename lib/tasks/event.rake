require "#{Rails.root}/app/helpers/events_helper"
include EventsHelper

GORKI_URI = 'https://www.gorki.de'.freeze
BERGHAIN_URI = 'https://www.berghain.berlin'.freeze
BERGHAIN_DEFAULT_IMG = 'https://cdn.berghain.berlin/static/images/berghain-logo.77d9d394ccd9.svg'.freeze

namespace :event do
  task :extract => :environment do
    puts "Start extracing event data"

    puts "===== Extract Gorki Data ====="
    # request to check which month allow to be queried
    # TODO: could find better way to reduce requests
    ping_uri = GORKI_URI + '/en/programme/'
    ping_request = RestClient.get(ping_uri).body
    available_uris = Nokogiri::HTML(ping_request).css('.schedule-filter--months li .schedule-filter--months--link').map{ |tag| GORKI_URI + tag['href'].strip }
    # query events by month
    available_uris.each do |query_uri|
      response = RestClient.get(query_uri).body
      # format would be https://www.gorki.de/en/programme/2020/05/all
      month_with_year = query_uri.gsub(ping_uri, '').gsub('/all', '').split('/').reverse.join('.')
      # extract all event and group by date
      gorki_events = Nokogiri::HTML(response).css('.schedule-item-list').each_with_object({}) do |section, obj|
        events = section.css('.h3').map(&:text).map(&:strip)
        links = section.css('.h3 a').map{ |tag| tag['href'].strip }
        imgs = section.css('picture img').map{ |tag| GORKI_URI + tag['src'] }
        date = "#{section.css('.schedule-item-list--date--day').text.strip}.#{month_with_year}"
        obj[datetime_formater(date)] = {
          events: events,
          links: links,
          imgs: imgs
        }
      end
      # use held_at / title / extract_from as flag to check if event existed
      # TODO: may have more efficient way on data extracting
      gorki_events.keys.each do |date_time|
        gorki_events[date_time][:events].each_with_index do |event, index|
          event = Event.find_or_create_by(held_at: date_time, title: event, extract_from: 'gorki')
          event_link = gorki_events[date_time][:links][index]
          event_img = gorki_events[date_time][:imgs][index]
          # check need update or not
          next if event.link == event_link && event.img_url == event_img
          event.update(link: event_link, img_url: event_img)
        end
      end
    end

    puts "===== Extract Berghain Data ====="
    # Berghain show events by month in this year
    current_year = Time.now.year
    current_month = Time.now.month
    (current_month..12).each do |month|
      formatted_month = '%.2d' % month
      query_uri = BERGHAIN_URI + "/en/program/archive/#{current_year}/#{formatted_month}"
      response = RestClient.get(query_uri).body
      Nokogiri::HTML(response).css('.upcoming-event').each do |section|
        title = section.css('h2').text.strip
        link = BERGHAIN_URI + section['href'].strip
        date_time = datetime_formater(section.css('p span').text.strip)
        # find and create event and check need updte or not
        event = Event.find_or_create_by(held_at: date_time, title: title, extract_from: 'berghain')
        next if event.link == link
        event.update(link: link, img_url: BERGHAIN_DEFAULT_IMG)
      end
    end
    puts "===== Finish Data Extract ====="
  end
end
