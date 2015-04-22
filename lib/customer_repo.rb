require 'csv'
require_relative 'customer'

class CustomerRepo
  attr_reader :engine, :customers

  def initialize(engine)
    @engine = engine
    @customers = []
  end

  def populate(csv_object)
    csv_object.each do |row|
      @customers << Customer.new(row[:id].to_i, row[:first_name], row[:last_name], row[:created_at], row[:updated_at])
    end
  end

  def all
    @customers
  end

  def random
    @customers.sample
  end

  def find_by_id(id)
    @customers.detect { |customer| customer.id == id }
  end

  def find_by_first_name(first_name)
    @customers.detect { |customer| customer.first_name == first_name }
  end

  def find_by_last_name(last_name)
    @customers.detect { |customer| customer.last_name == last_name }
  end

  def find_by_created_at(created_at)
    @customers.detect { |customer| customer.created_at == created_at }
  end

  def find_by_updated_at(updated_at)
    @customers.detect { |customer| customer.updated_at == updated_at }
  end

  def find_all_by_first_name(first_name)
    @customers.select { |customer| customer.first_name == first_name }
  end

  def find_all_by_last_name(last_name)
    @customers.select { |customer| customer.last_name == last_name }
  end

  def find_all_by_created_at(created_at)
    @customers.select { |customer| customer.created_at == created_at }
  end

  def find_all_by_updated_at(updated_at)
    @customers.select { |customer| customer.updated_at == updated_at }
  end

end