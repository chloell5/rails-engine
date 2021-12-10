class Merchant < ApplicationRecord
  has_many :items

  validates :name, presence: true

  def self.find_name(term)
    where('name ilike ?', "%#{term}%").order(:name)
  end
end
