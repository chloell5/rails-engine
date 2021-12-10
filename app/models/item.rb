class Item < ApplicationRecord
  belongs_to :merchant

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true
  validates :merchant_id, numericality: true, presence: true

  def self.find_name(term)
    where('name ilike ?', "%#{term}%").first
  end

  def self.find_min(price)
    where('unit_price >= ?', price).first
  end

  def self.find_max(price)
    where('unit_price <= ?', price).first
  end

  def self.find_between(min, max)
    where('unit_price > ? AND unit_price < ?', min, max).first
  end
end
