class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  validates_presence_of :name,
                        :description,
                        :unit_price,
                        :merchant_id



  def self.find_all_items_search(item)
    where("name ILIKE ?", "%#{item}%")
  end

  def self.find_by_min_price(price)
    where("unit_price >= ?", "#{price}").order(:name)
  end

  def self.find_by_max_price(price)
    where("unit_price <= ?", "#{price}").order(:name)
  end
end 