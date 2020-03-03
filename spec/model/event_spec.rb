require 'spec_helper'
include ActiveModel::Model
RSpec.describe Event, type: :model do
  let(:event) { build(:event) }

  it 'has a valid factory' do
    expect(event).to be_valid
  end

  it { is_expected.to validate_inclusion_of(:extract_from).in_array(Event::VALID_EXTRACT_SOURCE) }
  it { is_expected.to validate_uniqueness_of(:title).scoped_to(:held_at, :extract_from) }
end
