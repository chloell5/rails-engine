class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    if params[:item_id]
      render json: MerchantSerializer.new(Item.find(params[:item_id]).merchant)
    else
      render json: MerchantSerializer.new(Merchant.find(params[:id]))
    end
  end

  def find_all
    merchants = Merchant.find_name(params[:name])
    render json: MerchantSerializer.new(merchants)
  end
end
