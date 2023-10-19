require 'rails_helper'


RSpec.describe 'Items API' do
  describe 'index enpoint' do
    it "sends a formatted JSON response of all items" do
      create_list(:item, 10)


      get '/api/v1/items'


      expect(response).to be_successful


      parsed_response = JSON.parse(response.body, symbolize_names: true)
      
      items = parsed_response[:data]
      
      expect(items.count).to eq(10)


      items.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_an(String)


        expect(item).to have_key(:type)
        expect(item[:type]).to be_an(String) 


        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to be_an(Hash)
      end


      item_attributes = items.first[:attributes]
      
      expect(item_attributes).to have_key(:name) 
      expect(item_attributes[:name]).to be_an(String)


      expect(item_attributes).to have_key(:description)
      expect(item_attributes[:description]).to be_an(String)
      
      expect(item_attributes).to have_key(:unit_price) 
      expect(item_attributes[:unit_price]).to be_an(Float)


      expect(item_attributes).to have_key(:merchant_id)
      expect(item_attributes[:merchant_id]).to be_an(Integer)
    end
  end


  describe "show endpoint" do 
    it "sends a formatted JSON response for a single item" do
      id = create(:item).id
    
      get "/api/v1/items/#{id}"
      expect(response).to be_successful


      formatted_item = JSON.parse(response.body, symbolize_names: true)
      item = formatted_item[:data]


      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(String)


      expect(item).to have_key(:type)
      expect(item[:type]).to be_an(String)


      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_an(Hash)


      item_attributes = item[:attributes]


      expect(item_attributes).to have_key(:name) 
      expect(item_attributes[:name]).to be_an(String)


      expect(item_attributes).to have_key(:description)
      expect(item_attributes[:description]).to be_an(String)
      
      expect(item_attributes).to have_key(:unit_price) 
      expect(item_attributes[:unit_price]).to be_an(Float)


      expect(item_attributes).to have_key(:merchant_id)
      expect(item_attributes[:merchant_id]).to be_an(Integer)
    end
  end


  describe "post endpoint" do 
    it "creates a new item" do
      merchant = create(:merchant, id: 1)
      post "/api/v1/items", params: {item: {name: "New Item", description: "New Description", unit_price: 1.00, merchant_id: 1}}


      expect(response).to be_successful
      expect(response.status).to_not eq(404)
      expect(response.status).to eq(201)


      parsed_response = JSON.parse(response.body, symbolize_names: true)
      new_item = parsed_response[:data]


      expect(new_item).to have_key(:id)
      expect(new_item[:id]).to be_an(String)


      expect(new_item).to have_key(:type)
      expect(new_item[:type]).to be_an(String)


      expect(new_item).to have_key(:attributes)
      expect(new_item[:attributes]).to be_an(Hash)


      new_item_attributes = new_item[:attributes]


      expect(new_item_attributes).to have_key(:name)
      expect(new_item_attributes[:name]).to be_an(String)
      
      expect(new_item_attributes).to have_key(:description)
      expect(new_item_attributes[:description]).to be_an(String)


      expect(new_item_attributes).to have_key(:unit_price)
      expect(new_item_attributes[:unit_price]).to be_an(Float)
      
      expect(new_item_attributes).to have_key(:merchant_id)
      expect(new_item_attributes[:merchant_id]).to be_an(Integer)
    end
  end


  describe "delete endpoint" do
    it "deletes an item" do
      merchant = create(:merchant)
      items = create_list(:item, 10, merchant_id: merchant.id)


      item = items.first
      delete "/api/v1/items/#{item.id}"


      expect(response).to be_successful
      expect(response.status).to_not eq(404)
      expect(response.status).to eq(204)


      expect(Item.count).to eq(9)
      expect(merchant.items.count).to eq(9)
      expect(Item.where(id: item.id)).to_not exist
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end


  describe "update endpoint" do 
    it "sends a formatted JSON response of the updated item" do 
      merchant = create(:merchant, id: 1)
      merchant2 = create(:merchant, id: 2)
      item = create(:item, name: "Old Name", description: "Old Description", unit_price: 1.00, merchant_id: 1)
      id = item.id


      get "/api/v1/items/#{id}"
      current_item = JSON.parse(response.body, symbolize_names: true)
      expect(current_item[:data][:attributes][:name]).to eq("Old Name")
      expect(current_item[:data][:attributes][:description]).to eq("Old Description")


      patch "/api/v1/items/#{id}", params: {item: {name: "New Name", description: "New Description", unit_price: 2.00, merchant_id: 2}}


      updated_item = JSON.parse(response.body, symbolize_names: true)
      expect(updated_item[:data][:attributes][:name]).to eq("New Name")
      expect(updated_item[:data][:attributes][:description]).to eq("New Description")
    end


    it "still updates the item if only one attribute is passed in" do
        merchant2 = create(:merchant, id: 2)
        item = create(:item, name: "Old Name", description: "Old Description", unit_price: 1.00, merchant_id: 2)
        id = item.id
  
        get "/api/v1/items/#{id}"
        current_item = JSON.parse(response.body, symbolize_names: true)
        expect(current_item[:data][:attributes][:name]).to eq("Old Name")
  
        patch "/api/v1/items/#{id}", params: {item: {name: "New Name", merchant_id: 2}}
        expect(response).to be_successful
        expect(response.status).to_not eq(404)
        expect(response.status).to eq(200)
  
        updated_item = JSON.parse(response.body, symbolize_names: true)
        expect(updated_item[:data][:attributes][:name]).to eq("New Name")
    end
  end


  describe "merchant endpoint" do
    it "sends a formatted JSON response of the merchant for a single item" do
      merchant2 = create(:merchant, id: 2)
      item = create(:item,  merchant_id: 2)


      get "/api/v1/items/#{item.id}/merchant"
      expect(response).to be_successful
      expect(response.status).to_not eq(404)
      expect(response.status).to eq(200)


      parsed_response = JSON.parse(response.body, symbolize_names: true)


      merchant = parsed_response[:data]
      


      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)
      
      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to be_an(String)


      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_an(Hash)


      merchant_attributes = merchant[:attributes]


      expect(merchant_attributes).to have_key(:name)
      expect(merchant_attributes[:name]).to be_an(String)
    end
  end


  describe "search endpoint" do
    it "sends a formatted JSON response of all items that match the search criteria" do
      merchant  = create(:merchant, id: 1)
      item_1 = create(:item, name: "Old Shoes", merchant_id: 1)
      item_2 = create(:item, name: "Nice Shoes", merchant_id: 1)
      item_3 = create(:item, name: "Shirt", merchant_id: 1)
      item_4 = create(:item, name: "Pants", merchant_id: 1)


      get "/api/v1/items/find_all?name=shoes"
      formatted_response = JSON.parse(response.body, symbolize_names: true)
      items_returned = formatted_response[:data]


      expect(items_returned.count).to eq(2)
    end


    it "send a formatted response of all items by min price" do
      merchant  = create(:merchant, id: 1)
      item_1 = create(:item, name: "Old Shoes",unit_price: 10.01, merchant_id: 1)
      item_2 = create(:item, name: "Nice Shoes", unit_price: 18.45, merchant_id: 1)
      item_3 = create(:item, name: "Shirt", unit_price: 23.23, merchant_id: 1)
      item_4 = create(:item, name: "Pants", unit_price: 50.12, merchant_id: 1)


      get "/api/v1/items/find_all?min_price=20"
      formatted_response = JSON.parse(response.body, symbolize_names: true)
      items_returned = formatted_response[:data]


      expect(items_returned.count).to eq(2)


      items_returned.each do |item|
        expect(item[:attributes][:unit_price]).to be >= 20
      end
    end


    it "send a formatted response of all items by max price" do
      merchant  = create(:merchant, id: 1)
      item_1 = create(:item, name: "Old Shoes",unit_price: 10.01, merchant_id: 1)
      item_2 = create(:item, name: "Nice Shoes", unit_price: 18.45, merchant_id: 1)
      item_3 = create(:item, name: "Shirt", unit_price: 23.23, merchant_id: 1)
      item_4 = create(:item, name: "Pants", unit_price: 50.12, merchant_id: 1)


      get "/api/v1/items/find_all?max_price=20"
      formatted_response = JSON.parse(response.body, symbolize_names: true)
      items_returned = formatted_response[:data]


      expect(items_returned.count).to eq(2)


      items_returned.each do |item|
        expect(item[:attributes][:unit_price]).to be <= 20
      end
    end


    describe "sad path" do
      it "returns a 400 status code if no name and price parameters are both passed" do
        get "/api/v1/items/find_all?name=thing&min_price=20"


        expect(response).to_not be_successful
        expect(response.status).to eq(400)


        get "/api/v1/items/find_all?name=thing&max_price=20"


        expect(response).to_not be_successful
        expect(response.status).to eq(400)
      end 


      it "returns a 400 status code if a negative number is passed in for price" do
        get "/api/v1/items/find_all?min_price=-20"


        expect(response).to_not be_successful
        expect(response.status).to eq(400)
      end
    end
  end
end