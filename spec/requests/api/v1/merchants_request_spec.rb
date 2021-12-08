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
    # expect(merchants[:data]).to be_an(Array)
    # expect(merchants[:data].count).to eq(1)
    expect(merchants[:data]).to have_key(:id)
    expect(merchants[:data]).to have_key(:type)
    expect(merchants[:data][:type]).to eq('merchant')
    expect(merchants[:data][:attributes]).to have_key(:name)
    expect(merchants[:data][:attributes][:name]).to be_a String
  end
end
