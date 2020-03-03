require 'rails_helper'

RSpec.describe EventsHelper, type: :helper do
  context '#datetime_formater' do
    let(:date_time) { '03.03.2020' }

    it 'return formatted date' do
      expect(datetime_formater(date_time)).to eq (DateTime.new(2020, 3, 3))
    end

    context 'when input date_time with incorrect format' do
      let(:date_time) { '03-03-2020' }

      it 'raise custom error' do
        expect{ datetime_formater(date_time) }.to raise_error DateFormatError 
      end
    end
  end

  context '#cache_key_for_events' do
    before do
      helper.instance_variable_set(:@date_filter, date_filter)
      helper.instance_variable_set(:@extract_filter, extract_filter)
      helper.instance_variable_set(:@query, query)
      helper.instance_variable_set(:@events, Event.all)
    end

    let(:date_filter) { '03.03.2020' }
    let(:extract_filter) { 'gorki' }
    let(:query) { 'qqq' }
    let!(:events) { create_list(:event, 3) }
    let(:latest_updated_at) { events.pluck(:updated_at).max.to_f }

    it 'return correct cache_key' do
      expect(helper.cache_key_for_events).to eq ("events/index-#{date_filter}-#{extract_filter}-#{query}-#{latest_updated_at}")
    end
  end
end
