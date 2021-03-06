gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/transaction_repository'
require_relative '../lib/sales_engine'

class TransactionRepoTest < MiniTest::Test
  def test_points_back_to_its_parent
    se = SalesEngine.new('./data')
    assert se, se.transaction_repository.engine
  end

  def test_can_populate_from_csv_file
    se = SalesEngine.new('./data')
    se.populate_transaction_repo
    assert se.transaction_repository.transactions
  end

  def test_all_returns_an_array_of_all_transactions
    se = SalesEngine.new('./data')
    se.populate_transaction_repo
    assert_equal Array, se.transaction_repository.transactions.class
    refute se.transaction_repository.all.empty?
  end

  def test_random_returns_one_random_transaction_obj
    se = SalesEngine.new('./data')
    se.populate_transaction_repo
    assert_equal Transaction, se.transaction_repository.random.class
  end

  def test_find_a_transaction_by_id
    se = SalesEngine.new('./data')
    se.populate_transaction_repo
    assert_equal 40, se.transaction_repository.find_by_id(40).id
  end

  def test_find_a_transaction_by_invoice_id
    se = SalesEngine.new('./data')
    se.populate_transaction_repo
    assert_equal 79, se.transaction_repository.find_by_invoice_id(71).id
  end

  def test_find_a_transaction_by_cc_num
    se = SalesEngine.new('./data')
    se.populate_transaction_repo
    assert_equal 3866, se.transaction_repository.find_by_credit_card_number('4450739410040771').id
  end

  def test_find_a_transaction_by_result
    se = SalesEngine.new('./data')
    se.populate_transaction_repo
    assert_equal 1, se.transaction_repository.find_by_result("success").id
  end

  def test_it_can_find_by_created_at
    se = SalesEngine.new('./data')
    se.populate_transaction_repo
    assert_equal 976, se.transaction_repository.find_by_created_at("2012-03-27 14:54:50 UTC").id
  end

  def test_it_can_find_by_updated_at
    se = SalesEngine.new('./data')
    se.populate_transaction_repo
    assert_equal 5558, se.transaction_repository.find_by_updated_at("2012-03-27 14:58:14 UTC").id
  end

  def test_find_all_transactions_by_invoice_id
     se = SalesEngine.new('./data')
     se.populate_transaction_repo
     result = se.transaction_repository.find_all_by_invoice_id(12)
     assert_equal 3, result.size
  end

  def test_find_all_transactions_by_cc_num
    se = SalesEngine.new('./data')
    se.populate_transaction_repo
    result = se.transaction_repository.find_all_by_credit_card_number('4140149827486249')
    assert_equal 1, result.count
  end

  def test_find_all_transactions_by_result
    se = SalesEngine.new('./data')
    se.populate_transaction_repo
    result = se.transaction_repository.find_all_by_result("failed")
    assert_equal 947, result.count
  end

  def test_it_can_find_all_by_created_at
    se = SalesEngine.new('./data')
    se.populate_transaction_repo
    result = se.transaction_repository.find_all_by_created_at("2012-03-27 14:54:10 UTC")
    assert_equal 20, result.count
  end

  def test_it_can_find_all_by_updated_at
    se = SalesEngine.new('./data')
    se.populate_transaction_repo
    result = se.transaction_repository.find_all_by_updated_at("2012-03-27 14:54:09 UTC")
    assert_equal 2, result.count
  end

  def test_new_id_created
    se = SalesEngine.new('./data')
    se.populate_transaction_repo
    assert_equal 5596, se.transaction_repository.new_id
  end

  def test_new_transaction_created
    se = SalesEngine.new('./data')
    se.populate_transaction_repo
    se.transaction_repository.create('4640960137749750', '10/16', 'success', 23, "2012-03-27 14:54:09 UTC")
    transaction = se.transaction_repository.transactions.last
    assert_equal 5596, transaction.id
    assert_equal 23, transaction.invoice_id
    assert transaction.success?
  end
end
