require 'rails_helper'

describe 'Item API' do
  describe 'CRUD functionality' do
    it 'gets all items' do
      merchant = create(:merchant)
      create_list(:item, 10, merchant_id: merchant.id)

      get api_v1_items_path

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items).to be_a(Hash)
      expect(items[:data]).to be_an(Array)
      expect(items[:data].count).to eq(10)
      expect(items[:data].first).to have_key(:id)
      expect(items[:data].first).to have_key(:type)
      expect(items[:data].first[:type]).to eq('item')
      expect(items[:data].first[:attributes]).to have_key(:name)
      expect(items[:data].first[:attributes]).to have_key(:description)
      expect(items[:data].first[:attributes]).to have_key(:unit_price)
      expect(items[:data].first[:attributes][:name]).to be_a String
      expect(items[:data].first[:attributes][:description]).to be_a String
      expect(items[:data].first[:attributes][:unit_price]).to be_a Float
    end

    describe 'one item' do
      it 'gets one item' do
        merchant = create(:merchant)
        item = create(:item, merchant_id: merchant.id)

        get api_v1_item_path(item)

        expect(response).to be_successful

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items).to be_a(Hash)
        expect(items[:data]).to have_key(:id)
        expect(items[:data]).to have_key(:type)
        expect(items[:data][:type]).to eq('item')
        expect(items[:data][:attributes]).to have_key(:name)
        expect(items[:data][:attributes]).to have_key(:description)
        expect(items[:data][:attributes]).to have_key(:unit_price)
        expect(items[:data][:attributes][:name]).to be_a String
        expect(items[:data][:attributes][:description]).to be_a String
        expect(items[:data][:attributes][:unit_price]).to be_a Float
      end

      it '404s on invalid ID' do
        get '/api/v1/merchants/1111111'

        expect(response).to_not be_successful
        expect(response).to have_http_status(404)
      end
    end

    it 'creates an item' do
      merchant = create(:merchant)
      item_params = {
        name: 'Test',
        description: 'I really hope this works',
        unit_price: 123.45,
        merchant_id: merchant.id
      }

      headers = { 'CONTENT_TYPE' => 'application/json' }

      post api_v1_items_path, headers: headers, params: JSON.generate(item: item_params)

      item = Item.last

      expect(response).to be_successful

      expect(item.name).to eq(item_params[:name])
      expect(item.description).to eq(item_params[:description])
      expect(item.unit_price).to eq(item_params[:unit_price])
      expect(item.merchant_id).to eq(item_params[:merchant_id])
      expect(response).to have_http_status(201)
    end

    it 'edits an item' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)
      name = item.name
      description = item.description
      unit_price = item.unit_price
      item_params = {
        name: 'Test Edit',
        description: 'I really believe this will work',
        unit_price: 543.21
      }

      headers = { 'CONTENT_TYPE' => 'application/json' }

      patch api_v1_item_path(item), headers: headers, params: JSON.generate(item: item_params)

      item = Item.last

      expect(response).to be_successful

      expect(item.name).to eq(item_params[:name])
      expect(item.description).to eq(item_params[:description])
      expect(item.unit_price).to eq(item_params[:unit_price])

      expect(item.name).to_not eq(name)
      expect(item.description).to_not eq(description)
      expect(item.unit_price).to_not eq(unit_price)
    end

    it 'deletes an item' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      delete api_v1_item_path(item)

      expect(response).to be_successful
      expect(Item.count).to eq(0)
    end
  end

  it 'gets merchant data for an item' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      get api_v1_item_merchant_path(item)
      expect(response).to be_successful

      merchant_parse = JSON.parse(response.body, symbolize_names: true)

      expect(merchant_parse).to be_a(Hash)
      expect(merchant_parse[:data]).to have_key(:id)
      expect(merchant_parse[:data]).to have_key(:type)
      expect(merchant_parse[:data][:id].to_i).to eq(merchant.id)
      expect(merchant_parse[:data][:type]).to eq('merchant')
      expect(merchant_parse[:data][:attributes]).to have_key(:name)
      expect(merchant_parse[:data][:attributes][:name]).to be_a String
    end

  describe 'search functionality' do
    it 'searches for valid names and returns all' do
      merchant = Merchant.create!(name: 'Test Mer')
      item1 = Item.create!(name: 'Test Item', description: 'asd', unit_price: 1, merchant_id: merchant.id)
      item2 = Item.create!(name: 'Fail Item', description: 'asd', unit_price: 1, merchant_id: merchant.id)
      item3 = Item.create!(name: 'Another test', description: 'asd', unit_price: 1, merchant_id: merchant.id)

      get api_v1_items_find_path, params: { name: 'tesT' }

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data][:attributes][:name]).to eq(item3.name)
      expect(items[:data][:attributes][:name]).to_not include(item2.name, item1.name)
    end

    it 'searches by minimum unit price' do
      merchant = Merchant.create!(name: 'Test Mer')
      item1 = Item.create!(name: 'Small', description: 'asd', unit_price: 1, merchant_id: merchant.id)
      item2 = Item.create!(name: 'Med', description: 'asd', unit_price: 3, merchant_id: merchant.id)
      item3 = Item.create!(name: 'Large', description: 'asd', unit_price: 5, merchant_id: merchant.id)

      get api_v1_items_find_path, params: { min_price: 2 }

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data][:attributes][:name]).to eq(item3.name)
      expect(items[:data][:attributes][:name]).to_not include(item1.name, item2.name)
    end

    it 'searches by maximum unit price' do
      merchant = Merchant.create!(name: 'Test Mer')
      item1 = Item.create!(name: 'Small', description: 'asd', unit_price: 1, merchant_id: merchant.id)
      item2 = Item.create!(name: 'Med', description: 'asd', unit_price: 3, merchant_id: merchant.id)
      item3 = Item.create!(name: 'Large', description: 'asd', unit_price: 5, merchant_id: merchant.id)

      get api_v1_items_find_path, params: { max_price: 100 }

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data][:attributes][:name]).to eq(item3.name)
      expect(items[:data][:attributes][:name]).to_not include(item2.name, item1.name)
    end

    it 'searches between minimum and maximum unit price' do
      merchant = Merchant.create!(name: 'Test Mer')
      item1 = Item.create!(name: 'Small', description: 'asd', unit_price: 1, merchant_id: merchant.id)
      item2 = Item.create!(name: 'Med', description: 'asd', unit_price: 3, merchant_id: merchant.id)
      item3 = Item.create!(name: 'Large', description: 'asd', unit_price: 5, merchant_id: merchant.id)

      get api_v1_items_find_path, params: { min_price: 2, max_price: 6 }

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data][:attributes][:name]).to eq(item3.name)
      expect(items[:data][:attributes][:name]).to_not include(item1.name, item2.name)
    end
  end
end
