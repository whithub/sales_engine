gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/invoice_repo'
require './lib/sales_engine'

class InvoiceRepoTest < MiniTest::Test
  def test_points_back_to_its_parent
    se = SalesEngine.new
    assert se, se.invoice_repo.engine
  end

  def test_can_populate_from_csv_file
    se = SalesEngine.new
    se.populate_invoice_repo
    assert se.invoice_repo.invoices
  end

  def test_all_returns_an_array_of_invoices
    se = SalesEngine.new
    se.populate_invoice_repo
    assert_equal Array, se.invoice_repo.invoices.class
  end

  def test_random_returns_one_random_invoice_obj
    se = SalesEngine.new
    se.populate_invoice_repo
    assert_equal Invoice, se.invoice_repo.random.class
  end

  def test_find_an_invoice_by_id
    se = SalesEngine.new
    se.populate_invoice_repo
    assert_equal 12, se.invoice_repo.find_by_id(59).customer_id
  end

  def test_find_an_invoice_by_customer_id
    se = SalesEngine.new
    se.populate_invoice_repo
    assert_equal 268, se.invoice_repo.find_by_customer_id(59).id
  end

  def test_find_an_invoice_by_merchant_id
    se = SalesEngine.new
    se.populate_invoice_repo
    assert_equal 1, se.invoice_repo.find_by_merchant_id(26).id
  end

  def test_find_an_invoice_by_status
    se = SalesEngine.new
    se.populate_invoice_repo
    assert_equal 1, se.invoice_repo.find_by_status('shipped').id
  end

  def test_find_an_invoice_by_created_at
    se = SalesEngine.new
    se.populate_invoice_repo
    assert_equal 2, se.invoice_repo.find_by_created_at('2012-03-12 05:54:09 UTC').id
  end

  def test_find_an_invoice_by_updated_at
    se = SalesEngine.new
    se.populate_invoice_repo
    assert_equal 4, se.invoice_repo.find_by_updated_at('2012-03-24 15:54:10 UTC').id
  end

  def test_find_all_invoices_by_customer_id
    se = SalesEngine.new
    se.populate_invoice_repo
    assert_equal 8, se.invoice_repo.find_all_by_customer_id(10).size
  end

  def test_find_all_invoices_by_merchant_id
    se = SalesEngine.new
    se.populate_invoice_repo
    assert_equal 59, se.invoice_repo.find_all_by_merchant_id(1).size
  end

  def test_find_all_invoices_by_status
    se = SalesEngine.new
    se.populate_invoice_repo
    assert_equal 4843, se.invoice_repo.find_all_by_status('shipped').size
  end

  def test_find_all_invoices_by_created_at
    se = SalesEngine.new
    se.populate_invoice_repo
    assert_equal 1, se.invoice_repo.find_all_by_created_at('2012-03-13 16:54:10 UTC').size
  end

  def test_find_all_invoices_by_updated_at
    se = SalesEngine.new
    se.populate_invoice_repo
    assert_equal 1, se.invoice_repo.find_all_by_updated_at('2012-03-12 03:54:10 UTC').size
  end

  def test_create_the_next_id_for_a_new_invoice
    se = SalesEngine.new
    se.populate_invoice_repo
    assert_equal 4844, se.invoice_repo.new_id
  end

  # def test_create_new_invoices
  #   se = SalesEngine.new
  #   se.startup
  #   se.invoice_repo.create(customer: "Joey Ondricka", merchant: "Willms and Sons", status: "shipped", items: [])
  #
  # end

end
