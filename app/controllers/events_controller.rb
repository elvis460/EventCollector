class EventsController < ApplicationController
  include EventsHelper

  def index
    @date_filter = params[:date_filter].presence
    @extract_filter = params[:extract_filter] || 'all'
    @query = params[:query].presence

    respond_to do |format|
      format.html { render :index }
      format.json do
        result = Rails.cache.fetch(cache_key_for_events, expires_in: 12.hours) do
          # allow combined filters
          if @date_filter
            @events = Event.where(held_at: datetime_formater(@date_filter).beginning_of_day)
          else
            # default will query events after today
            @events = Event.where('events.held_at >= ?', Date.today.beginning_of_day)
          end

          if @extract_filter != 'all'
            @events = @events.where(extract_from: @extract_filter)
          end

          if @query
            # TODO: create index for partial query
            @events = @events.where("title like ?", "%#{@query}%")
          end
          # group events by held_at to show them by date
          @events.order(held_at: :asc).group_by{ |event| event.held_at.strftime("%d.%m.%Y") }
        end

        render json: { events: result, date_list: result.keys }
      end
    end
  end
end
