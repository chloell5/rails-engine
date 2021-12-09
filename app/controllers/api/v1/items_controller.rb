class Api::V1::ItemsController < ApplicationController
  def index
    if params[:merchant_id]
      render json: ItemSerializer.new(Merchant.find(params[:merchant_id]).items)
    else
      render json: ItemSerializer.new(Item.all)
    end
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    render json: ItemSerializer.new(Item.create!(item_params)), status: 201
  end

  def update
    validate_merchant_id
    render json: ItemSerializer.new(Item.update(params[:id], item_params))
  end

  def destroy
    Item.delete(params[:id])
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

  def validate_merchant_id
    if params[:merchant_id]
      merchant = Merchant.find_by(id: params[:merchant_id])
      raise ActionController::BadRequest unless merchant
    end
  end
end
