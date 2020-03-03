require 'rails_helper'

RSpec.describe 'events', type: :routing do
  it '#index' do
    expect(get: '/events').to route_to('events#index')
  end
end