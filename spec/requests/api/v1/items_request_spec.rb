require 'rails_helper'

describe 'Item API' do
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

  it 'gets one item' do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)

    get api_v1_item_path(item)

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items).to be_a(Hash)
<<<<<<< HEAD
    # expect(items[:data]).to be_an(Array)
    # expect(items[:data].count).to eq(1)
=======
>>>>>>> 4ff2ae6e4a2d270bf9ca14ea22eb2e04c6f313d2
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
end
