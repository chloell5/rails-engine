class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    if params[:item_id]
      render json: MerchantSerializer.new(Item.find(params[:item_id]).merchant)
    elsif merchant = Merchant.find_by(id: params[:id])
      render json: MerchantSerializer.new(merchant)
    else
      render status: 404
    end
  end

  def find_all
    render json: MerchantSerializer.new(Merchant.find_name(params[:name]))
  end
end
