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

  it 'creates an item' do
    merchant = create(:merchant)
    item_params = {
                    name: "Test",
                    description: "I really hope this works",
                    unit_price: 123.45,
                    merchant_id: merchant.id
                  }

    headers = {"CONTENT_TYPE" => "application/json"}

    post api_v1_items_path, headers: headers, params: JSON.generate(item: item_params)

    item = Item.last

    expect(response).to be_successful

    expect(item.name).to eq(item_params[:name])
    expect(item.description).to eq(item_params[:description])
    expect(item.unit_price).to eq(item_params[:unit_price])
    expect(item.merchant_id).to eq(item_params[:merchant_id])
  end

  it 'edits an item' do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)
    name = item.name
    description = item.description
    unit_price = item.unit_price
    item_params = {
                    name: "Test Edit",
                    description: "I really believe this will work",
                    unit_price: 543.21,
                  }

    headers = {"CONTENT_TYPE" => "application/json"}

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
