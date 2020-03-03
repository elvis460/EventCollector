class Event < ApplicationRecord
  VALID_EXTRACT_SOURCE = %w(gorki berghain)

  validates :extract_from, inclusion: { in: VALID_EXTRACT_SOURCE }
  validates_uniqueness_of :title, scope: [:held_at, :extract_from]
end
