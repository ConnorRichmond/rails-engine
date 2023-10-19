require 'rails_helper' 

RSpec.describe InvoiceItem, type: :model do 
  describe "relationships" do
    it "should belong to an item" do 
      expect(InvoiceItem.reflect_on_association(:item).macro).to eq(:belongs_to)
      expect(InvoiceItem.reflect_on_association(:invoice).macro).to eq(:belongs_to)
    end
  end
end