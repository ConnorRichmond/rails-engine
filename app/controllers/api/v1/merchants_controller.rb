class Api::V1::MerchantsController < ApplicationController
  before_action :find_merchant, only: [:show, :items]

  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(find_merchant)
  end
  

def find_one 
  @merchant = Merchant.find_by_name(params[:name])

  if @merchant
    render json: MerchantSerializer.new(@merchant)
  else
    render json: { data: {id: nil, type: nil, attributes:{}} }, status: 200
  end 
end

  private

  def find_merchant
    @merchant = Merchant.find(params[:id])
  end
end