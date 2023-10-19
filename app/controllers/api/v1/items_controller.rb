class Api::V1::ItemsController < ApplicationController
  before_action :find_item, only: [:show, :update, :destroy]
  
  def index
    render_items(Item.all)
  end


  def show
    render_item(@item)
  end


  def create
    item = Item.new(item_params)
    if item.save
      render_item(item, status: :created)
    else
      render_errors(item.errors.full_messages, :unprocessable_entity)
    end
  end


  def update
    if @item.update(item_params)
      render_item(@item)
    else
      render_errors(@item.errors.full_messages, :bad_request)
    end
  end


  def destroy
    @item.destroy
    head :no_content
  end


  def search
    if params[:name].present? && (params[:min_price].present? || params[:max_price].present?)
      render_errors("Please enter only one search parameter (name, min_price, or max_price)", :bad_request)
    elsif params[:name].present?
      render_items(Item.find_all_items_search(params[:name]))
    elsif params[:min_price].present?
      min_price = params[:min_price].to_f
      if min_price < 0
        render_errors("Please enter a positive number for min_price", :bad_request)
      else
        render_items(Item.find_by_min_price(min_price))
      end
    elsif params[:max_price].present?
      max_price = params[:max_price].to_f
      if max_price < 0
        render_errors("Please enter a positive number for max_price", :bad_request)
      else
        render_items(Item.find_by_max_price(max_price))
      end
    else
      render_errors("Please enter a search parameter (name, min_price, or max_price)", :bad_request)
    end
  end


  private


  def find_item
    @item = Item.find(params[:id])
  end


  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end


  def render_item(item, status: :ok)
    render json: ItemSerializer.new(item), status: status
  end


  def render_items(items, status: :ok)
    render json: ItemSerializer.new(items), status: status
  end


  def render_errors(errors, status)
    render json: { errors: errors }, status: status
  end
end