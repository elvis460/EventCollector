class EventsController < ApplicationController
  include EventsHelper

  def index
    @date_filter = params[:date_filter].presence
    @extract_filter = params[:extract_filter] || 'all'
    @query = params[:query].presence

    respond_to do |format|
      format.html { render :index }
      format.json do
        # allow combined filters
        @events = if @date_filter
                    Event.where(held_at: datetime_formater(@date_filter).beginning_of_day)
                  else
                    # default will query events after today
                    Event.where('events.held_at >= ?', Date.today.beginning_of_day)
                  end

        @events = @events.where(extract_from: @extract_filter) if @extract_filter != 'all'

        # TODO: create index for partial query
        @events = @events.where("title like ?", "%#{@query}%") if @query

        result = Rails.cache.fetch(cache_key_for_events, expires_in: 12.hours) do
          # group events by held_at to show them by date
          @events.order(held_at: :asc).group_by{ |event| event.held_at.strftime("%d.%m.%Y") }
        end

        # consider to add pagination for huge data
        render json: { events: result, date_list: result.keys }
      end
    end
  rescue DateFormatError => e
    Rails.logger.error e.to_s
    head :bad_request
  rescue => e
    Rails.logger.error e.to_s
    head :internal_server_error
  end
end
