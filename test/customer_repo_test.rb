gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/customer_repository'
require_relative '../lib/sales_engine'

class CustomerRepoTest < MiniTest::Test
  def test_points_back_to_its_parent
    se = SalesEngine.new('./data')
    assert se, se.customer_repository.engine
  end

  def test_can_populate_from_csv_file
    se = SalesEngine.new('./data')
    se.populate_customer_repo
    assert se.customer_repository.customers
  end

  def test_all_returns_an_array_of_customers
    se = SalesEngine.new('./data')
    se.populate_customer_repo
    assert_equal Array, se.customer_repository.customers.class
  end

  def test_random_returns_one_random_customer_obj
    se = SalesEngine.new('./data')
    se.populate_customer_repo
    assert_equal Customer, se.customer_repository.random.class
  end

  def test_find_a_customer_by_id
    se = SalesEngine.new('./data')
    se.populate_customer_repo
    assert_equal "Katrina", se.customer_repository.find_by_id(13).first_name
  end

  def test_find_a_customer_by_first_name
    se = SalesEngine.new('./data')
    se.populate_customer_repo
    assert_equal 13, se.customer_repository.find_by_first_name("Katrina").id
  end

  def test_find_a_customer_by_last_name
    se = SalesEngine.new('./data')
    se.populate_customer_repo
    assert_equal 16, se.customer_repository.find_by_last_name("Hoppe").id
  end

  def test_find_a_customer_by_created_at
    se = SalesEngine.new('./data')
    se.populate_customer_repo
    assert_equal 2, se.customer_repository.find_by_created_at("2012-03-27 14:54:10 UTC").id
  end

  def test_find_a_customer_by_updated_at
    se = SalesEngine.new('./data')
    se.populate_customer_repo
    assert_equal 39, se.customer_repository.find_by_updated_at("2012-03-27 14:54:19 UTC").id
  end

  def test_find_all_customers_by_first_name
    se = SalesEngine.new('./data')
    se.populate_customer_repo
    assert_equal 2, se.customer_repository.find_all_by_first_name("Kim").size
    assert_equal 1, se.customer_repository.find_all_by_first_name("Ruby").size
  end

  def test_find_all_customers_by_last_name
    se = SalesEngine.new('./data')
    se.populate_customer_repo
    assert_equal 2, se.customer_repository.find_all_by_last_name("Stark").size
  end

  def test_find_all_customers_by_created_at
    se = SalesEngine.new('./data')
    se.populate_customer_repo
    assert_equal 6, se.customer_repository.find_all_by_created_at("2012-03-27 14:54:10 UTC").size
  end

  def test_find_all_customers_by_updated_at
    se = SalesEngine.new('./data')
    se.populate_customer_repo
    assert_equal 3, se.customer_repository.find_all_by_updated_at("2012-03-27 14:54:14 UTC").size
  end

  def test_find_merchant_by_id
    se = SalesEngine.new('./data')
    se.populate_merchant_repo
    assert_equal 'Kozey Group', se.customer_repository.find_merchant(12).name
  end

  def test_find_customer_by_full_name
    se = SalesEngine.new('./data')
    se.populate_customer_repo
    assert_equal 'Frami', se.customer_repository.find_by_full_name('Ashly Frami').last_name
  end

  def test_find_customer_with_most_items
    se = SalesEngine.new('./data')
    se.populate_transaction_repo
    se.populate_invoice_item_repo
    se.populate_invoice_repo
    se.populate_customer_repo
    top_customer = se.customer_repository.most_items
    assert_equal 622, top_customer.id
  end

  def test_find_customer_with_most_revenue
    se = SalesEngine.new('./data')
    se.populate_transaction_repo
    se.populate_invoice_item_repo
    se.populate_invoice_repo
    se.populate_customer_repo
    top_customer = se.customer_repository.most_revenue
    assert_equal 601, top_customer.id
    assert_equal '201936.96', top_customer.revenue.to_digits
  end

end

