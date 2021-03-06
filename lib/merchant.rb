require 'bigdecimal'
require 'bigdecimal/util'

class Merchant

  attr_reader :id,
              :name,
              :created_at,
              :updated_at,
              :repo

  def initialize(id, name, created_at, updated_at, repo)
    @id = id
    @name = name
    @created_at = created_at
    @updated_at = updated_at
    @repo = repo
  end

  def customers_with_pending_invoices
    cust_ids = unsuccessful_invoices.map(&:customer_id).uniq
    cust_ids.map { |id| @repo.find_customer(id) }
  end

  def unsuccessful_invoices
    invoices.select do |invoice|
      invoice.successful? == false
    end
  end

  def successful_invoices
    invoices.select(&:successful?)
  end

  def success_invoice_by_customer_id
    successful_invoices.group_by(&:customer_id)
  end

  def worst_to_best_customer
    success_invoice_by_customer_id.map do |cust_id, invoices|
      [invoices.size, cust_id]
    end
  end

  def favorite_customer
    winner = worst_to_best_customer.sort_by(&:first).last
    winner_id = winner.last
    @repo.find_customer(winner_id)
  end

  def revenue(date=nil)
    if date.nil?
      invoices.map { |invoice| invoice.revenue}.reduce(:+)
    else
      revenue_by_date(date)
    end
  end

  def revenue_by_date(date)
    invoices_for_date = invoices.select do |invoice|
      Date.parse(invoice.created_at[0..9]) == date
    end
    invoices_for_date.map(&:revenue).reduce(:+)
  end

  def items
    repo.items(id)
  end

  def invoices
    repo.invoices(id)
  end

  def quantity
    invoices.map(&:quantity).reduce(:+)
  end

end
