require 'rails_helper'

RSpec.describe Item do
  describe 'relationships' do
    it { should belong_to(:merchant) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_presence_of(:merchant_id) }
  end

  describe 'methods' do
    before do
      @merchant = Merchant.create!(name: 'Test Mer')
      @item1 = Item.create!(name: 'Small', description: 'asd', unit_price: 1, merchant_id: @merchant.id)
      @item2 = Item.create!(name: 'Med', description: 'asd', unit_price: 3, merchant_id: @merchant.id)
      @item3 = Item.create!(name: 'Large', description: 'asd', unit_price: 5, merchant_id: @merchant.id)
    end

    it 'can find items by name' do
      expect(Item.find_name('e')).to eq(@item3)
    end

    it 'can find items by min' do
      expect(Item.find_min(4)).to eq(@item3)
    end

    it 'can find items by max' do
      expect(Item.find_max(2)).to eq(@item1)
    end

    it 'searches between minimum and maximum unit price' do
      expect(Item.find_between(2, 4)).to eq(@item2)
    end
  end
end
