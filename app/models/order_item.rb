class OrderItem < ActiveRecord::Base
	belongs_to :product
	belongs_to :order

	validates :quantity, presence: true, numericality: {only_integer: true, greater_than: 0 }
	validate :sku_present
	validate :order_present

	before_save :finalize

	def unit_price
		if persisted?
			self[:price_per_unit]
		else
			sku.price_per_unit
		end
	end

	def total_price
		price_per_unit * quantity
	end

	private
	def product_present
		if sku.nil?
			errors.add(:sku, "is not valid or active at this time.")
		end
	end

	def order_present
		if order.nil?
			errors.add(:order, "is not a valid order.")
		end
	end

	def finalize
		self[:price_per_unit] = price_per_unit
		self[:total_price] = quantity * self[:price_per_unit]
	end

end
