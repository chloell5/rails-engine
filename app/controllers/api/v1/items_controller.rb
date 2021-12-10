class Api::V1::ItemsController < ApplicationController
  def index
    if params[:merchant_id]
      render json: ItemSerializer.new(Merchant.find(params[:merchant_id]).items)
    else
      render json: ItemSerializer.new(Item.all)
    end
  end

  def show
    if item = Item.find_by(id: params[:id])
      render json: ItemSerializer.new(item)
    else
      render status: 404
    end
  end

  def create
    if item = Item.create!(item_params)
      render json: ItemSerializer.new(item), status: 201
    else
      render status: 400
    end
  end

  def update
    if item = Item.update(params[:id], item_params)
      render json: ItemSerializer.new(item)
    else
      render status: 400
    end
  end

  def destroy
    Item.delete(params[:id])
  end

  def find
    case
    when params[:name] && !params[:min_price] && !params[:max_price]
      render json: ItemSerializer.new(Item.find_name(params[:name]))
    when params[:min_price] && params[:max_price] && !params[:name]
      render json: ItemSerializer.new(Item.find_between(params[:min_price], params[:max_price]))
    when params[:min_price] && !params[:name]
      render json: ItemSerializer.new(Item.find_min(params[:min_price]))
    when params[:max_price] && !params[:name]
      render json: ItemSerializer.new(Item.find_max(params[:max_price]))
    else
      render status: 400
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
