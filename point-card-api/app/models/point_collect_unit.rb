class PointCollectUnit < ApplicationRecord

  belongs_to :point_card

  validates :point_card_id, presence: true
  validates :name, presence: true
  validates :name, length: { in: 2..100 }
  validates :description, length: { maximum: 1000 }
  validates :point, presence: true
  validates :point, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
end
