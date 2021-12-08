require 'rails_helper'

describe 'Merchant API' do
  it 'gets all merchants' do
    create_list(:merchant, 10)

    get api_v1_merchants_path

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants).to be_a(Hash)
    expect(merchants[:data]).to be_an(Array)
    expect(merchants[:data].count).to eq(10)
    expect(merchants[:data].first).to have_key(:id)
    expect(merchants[:data].first).to have_key(:type)
    expect(merchants[:data].first[:type]).to eq('merchant')
    expect(merchants[:data].first[:attributes]).to have_key(:name)
    expect(merchants[:data].first[:attributes][:name]).to be_a String
  end

  it 'gets one merchant' do
    merchant = create(:merchant)

    get api_v1_merchant_path(merchant)

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants).to be_a(Hash)
    expect(merchants[:data]).to have_key(:id)
    expect(merchants[:data]).to have_key(:type)
    expect(merchants[:data][:type]).to eq('merchant')
    expect(merchants[:data][:attributes]).to have_key(:name)
    expect(merchants[:data][:attributes][:name]).to be_a String
  end

  it 'gets a merchants items' do
    merchant = create(:merchant)
    create_list(:item, 10, merchant_id: merchant.id)

    get api_v1_merchant_items_path(merchant)

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
end
