require 'rails_helper'

RSpec.describe 'Merchants API' do
  describe 'all merchants endoint' do 
    it "send a formatted JSON reponse of all merchants" do 
      create_list(:merchant, 10)

      get '/api/v1/merchants'

      expect(response).to be_successful

      parsed_response = JSON.parse(response.body, symbolize_names: true)
      merchants = parsed_response[:data]
      # require 'pry';binding.pry
      expect(merchants.count).to eq(10)

      merchants.each do |merchant|
        expect(merchant).to have_key(:id) 
        expect(merchant[:id]).to be_an(String)
        
        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to be_an(String)

        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes]).to be_an(Hash)
      end
    end
  end 

  describe "merchant show endpoint" do 
    it "sends a formatted JSON response of a single merchant" do
      id = create(:merchant).id

      get "/api/v1/merchants/#{id}"
      formatted_merchant = JSON.parse(response.body, symbolize_names: true)
      merchant = formatted_merchant[:data]
      # require 'pry';binding.pry
      expect(response).to be_successful

      expect(merchant).to have_key(:id) 
      expect(merchant[:id]).to be_an(String)
      
      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to be_an(String)

      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_an(Hash)
    end
  end

  describe "items for a merchant endpoint" do
    it "sends a formatted JSON response of all items for a merchant" do
      id = create(:merchant).id
      items = create_list(:item, 10, merchant_id: id)

      get "/api/v1/merchants/#{id}/items"
      
      formatted_items = JSON.parse(response.body, symbolize_names: true)
      items = formatted_items[:data]

      items.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_an(String)

        expect(item).to have_key(:type)
        expect(item[:type]).to be_a(String)

        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to be_a(Hash)
      end

      item_atttributes = items.first[:attributes]

      expect(item_atttributes).to have_key(:name)
      expect(item_atttributes[:name]).to be_a(String)
      
      expect(item_atttributes).to have_key(:description)
      expect(item_atttributes[:description]).to be_a(String)

      expect(item_atttributes).to have_key(:unit_price)
      expect(item_atttributes[:unit_price]).to be_a(Float)

      expect(item_atttributes).to have_key(:merchant_id)
      expect(item_atttributes[:merchant_id]).to be_a(Integer)
    end
  end

  describe "find_one merchant endpoint" do 
    it "send a formatted JSON response for a single merchant based on a 'name' paramter" do 
      merchant_1 = create(:merchant, name: "Dick's sporting Goods")
      merchant_2 = create(:merchant, name: "Walmart")
      merchant_3 = create(:merchant, name: "IME Outfitter's")

      get "/api/v1/merchants/find?name=dic"
      expect(response.status).to eq(200)
      formatted_merchant = JSON.parse(response.body, symbolize_names: true)
      merchant = formatted_merchant[:data]

      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to be_a(String)

      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_an(Hash)
    end
    it " returns and empty hash if no data is passed to the parameter" do 
      get "/api/v1/merchants/find?name="
      expect(response.status).to eq(200)
      formatted_merchant = JSON.parse(response.body, symbolize_names: true)
      merchant = formatted_merchant[:data]

      expect(merchant).to eq({id: nil, type: nil, attributes:{}})
    end
  end
end