require 'csv'
require_relative 'invoice_item'

class InvoiceItemRepo
  attr_reader :engine, :invoice_items

  def initialize(engine)
    @engine = engine
    @invoice_items = []
  end

  def populate(csv_object)
    csv_object.each do |row|
      @invoice_items << InvoiceItem.new(row[:id].to_i, row[:item_id].to_i,
                                        row[:invoice_id].to_i, row[:quantity].to_i,
                                        row[:unit_price].to_i, row[:created_at],
                                        row[:updated_at], self)
    end
  end

  def new_id
    @invoice_items.last.id + 1
  end

  def create(items, invoice_id, date)
    item_objects = items.map { |item_name| @engine.items_repo.find_by_name(item_name) }
    grouped_items = item_objects.group_by { |item| item }
    item_and_quantity = grouped_items.map { |item, items| [item, items.size] }
    item_and_quantity.each do |item, quantity|
      @invoice_items << InvoiceItem.new(new_id, item.id, invoice_id, quantity, item.unit_price, date, date, self)
    end
  end

  def invoice(invoice_id)
    @engine.invoice_repo.find_by_id(invoice_id)
  end

  def item(item_id)
    @engine.items_repo.find_by_id(item_id)
  end

  def all
    @invoice_items
  end

  def random
    @invoice_items.sample
  end

  def find_by_id(id)
    @invoice_items.detect { |invoice_item| invoice_item.id == id }
  end

  def find_by_item_id(item_id)
    @invoice_items.detect { |invoice_item| invoice_item.item_id == item_id }
  end

  def find_by_invoice_id(invoice_id)
    @invoice_items.detect { |invoice_item| invoice_item.invoice_id == invoice_id }
  end

  def find_by_quantity(quantity)
    @invoice_items.detect { |invoice_item| invoice_item.quantity == quantity }
  end

  def find_by_unit_price(unit_price)
    @invoice_items.detect { |invoice_item| invoice_item.unit_price == unit_price }
  end

  def find_by_created_at(created_at)
    @invoice_items.detect { |invoice_item| invoice_item.created_at == created_at }
  end

  def find_by_updated_at(updated_at)
    @invoice_items.detect { |invoice_item| invoice_item.updated_at == updated_at }
  end

  def find_all_by_item_id(item_id)
    @invoice_items.select { |invoice_item| invoice_item.item_id == item_id }
  end

  def find_all_by_invoice_id(invoice_id)
    @invoice_items.select { |invoice_item| invoice_item.invoice_id == invoice_id }
  end

  def find_all_by_quantity(quantity)
    @invoice_items.select { |invoice_item| invoice_item.quantity == quantity }
  end

  def find_all_by_unit_price(unit_price)
    @invoice_items.select { |invoice_item| invoice_item.unit_price == unit_price }
  end

  def find_all_by_created_at(created_at)
    @invoice_items.select { |invoice_item| invoice_item.created_at == created_at }
  end

  def find_all_by_updated_at(updated_at)
    @invoice_items.select { |invoice_item| invoice_item.updated_at == updated_at }
  end
end
