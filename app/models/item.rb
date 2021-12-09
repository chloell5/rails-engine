class Item < ApplicationRecord
  belongs_to :merchant

  validates :merchant_id, numericality: true, presence: true
end
