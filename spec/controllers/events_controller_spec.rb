require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  describe '#index' do
    let!(:event) { create(:event, held_at: Date.today.beginning_of_day, extract_from: 'gorki') }
    let!(:ytd_event) { create(:event, held_at: (Date.today - 1).beginning_of_day, extract_from: 'berghain') }
    let!(:tmr_event) { create(:event, held_at: (Date.today + 1).beginning_of_day, extract_from: 'berghain') }
    let(:tdy_formatted_date) { event.held_at.strftime('%d.%m.%Y') }
    let(:tmr_formatted_date) { tmr_event.held_at.strftime('%d.%m.%Y') }

    context 'when query without params' do
      it 'render index page' do
        get :index
        expect(response).to render_template(:index)
      end

      it 'return events beyond today if request with json format' do
        get :index, format: :json
        expect(response).to have_http_status(200)

        result = JSON.parse(response.body)

        expect(result['events']).to eq(Hash[
          tdy_formatted_date, Array.wrap(event.as_json),
          tmr_formatted_date, Array.wrap(tmr_event.as_json)
        ])
        expect(result['date_list']).to eq([tdy_formatted_date, tmr_formatted_date])
      end
    end

    context 'when query with params' do
      let(:params) do
        {
          date_filter: date_filter,
          extract_filter: extract_filter,
          query: query
        }
      end
      let(:date_filter) { nil }
      let(:extract_filter) { 'all' }
      let(:query) { '' }

      context 'and filtet by date' do
        let(:date_filter) { Date.today.strftime('%d.%m.%Y') }

        it 'return filtered events' do
          get :index, params: params, format: :json

          result = JSON.parse(response.body)

          expect(result['events']).to eq(Hash[tdy_formatted_date, Array.wrap(event.as_json)])
          expect(result['date_list']).to eq(Array(tdy_formatted_date))
        end
      end

      context 'and filtet by extract_from' do
        let(:extract_filter) { 'berghain' }

        it 'return filtered events beyond today' do
          get :index, params: params, format: :json

          result = JSON.parse(response.body)

          expect(result['events']).to eq(Hash[tmr_formatted_date, Array.wrap(tmr_event.as_json)])
          expect(result['date_list']).to eq(Array(tmr_formatted_date))
        end
      end

      context 'and filtet by keyword' do
        let(:query) { event.title.split().first }

        it 'return filtered events beyond today' do
          get :index, params: params, format: :json

          result = JSON.parse(response.body)

          expect(result['events']).to eq(Hash[tdy_formatted_date, Array.wrap(event.as_json)])
          expect(result['date_list']).to eq(Array(tdy_formatted_date))
        end
      end

      context 'and filtet by both date and extract_from' do
        let(:date_filter) { Date.today.strftime('%d.%m.%Y') }
        let(:extract_filter) { 'berghain' }
        let!(:event_from_berghain) { create(:event, held_at: Date.today.beginning_of_day, extract_from: 'berghain') }

        it 'return filtered events beyond today' do
          get :index, params: params, format: :json

          result = JSON.parse(response.body)

          expect(result['events']).to eq(Hash[tdy_formatted_date, Array.wrap(event_from_berghain.as_json)])
          expect(result['date_list']).to eq(Array(tdy_formatted_date))
        end
      end

      context 'when query with invalid date format' do
        let(:date_filter) { Date.today.strftime('%d-%m-%Y') }

        it 'return 400' do
          get :index, params: params, format: :json

          expect(response).to have_http_status(400)
        end
      end
    end
  end
end
