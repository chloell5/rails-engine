require 'rails_helper'

RSpec.describe Merchant do
  describe 'relationships' do
    it { should have_many(:items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'methods' do
    it 'can find merchants by name' do
      merchant1 = Merchant.create(name: "Test 1")
      merchant2 = Merchant.create(name: "Test 2")
      merchant3 = Merchant.create(name: "Fail 1")
      merchant4 = Merchant.create(name: "Another test")

      expect(Merchant.find_name('tesT')).to eq([merchant4, merchant1, merchant2])
      expect(Merchant.find_name('tesT')).to_not include(merchant3)
    end
  end
end
