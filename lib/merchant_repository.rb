require 'csv'
require_relative 'merchant'
require 'bigdecimal'
require 'bigdecimal/util'


class MerchantRepository
  attr_reader :engine, :merchants

  def initialize(engine)
    @engine = engine
    @merchants = []
  end

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end

  def populate(csv_object)
    csv_object.each do |row|
      @merchants << Merchant.new(
        row[:id].to_i,
        row[:name],
        row[:created_at],
        row[:updated_at],
        self
      )
    end
  end

  def items(id)
    @engine.item_repository.find_all_by_merchant_id(id)
  end

  def invoices(id)
    @engine.invoice_repository.find_all_by_merchant_id(id)
  end

  def all
    @merchants
  end

  def random
    @merchants.sample
  end

  def find_by_id(id)
    @merchants.detect { |merchant| merchant.id == id }
  end

  def find_by_name(name)
    @merchants.detect { |merchant| merchant.name == name }
  end

  def find_by_created_at(date)
    @merchants.detect { |merchant| merchant.created_at == date }
  end

  def find_by_updated_at(date)
    @merchants.detect { |merchant| merchant.updated_at == date }
  end

  def find_all_by_name(name)
    @merchants.select { |merchant| merchant.name.downcase == name.downcase}
  end

  def find_all_by_created_at(date)
    @merchants.select { |merchant| merchant.created_at == date }
  end

  def find_all_by_updated_at(date)
    @merchants.select { |merchant| merchant.updated_at == date}
  end

  def most_revenue(num)
    @merchants.sort_by { |merchant| -merchant.revenue}.take(num)
  end

  def revenue(date)
    viable_merchants = @merchants.select do |merchant|
      merchant.invoices.any? do |invoice|
        Date.parse(invoice.created_at[0..9]) == date
      end
    end
    viable_merchants.map { |merchant| merchant.revenue(date) }.reduce(:+)
  end

  def most_items(num)
    @merchants.sort_by { |merchant| -merchant.quantity}.take(num)
  end

  def find_customer(customer_id)
    @engine.customer_repository.find_by_id(customer_id)
  end

end
