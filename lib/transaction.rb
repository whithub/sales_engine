class Transaction
  attr_reader :id, :invoice_id, :credit_card_number, :credit_card_expiration_date, :result, :created_at, :updated_at

  def initialize(id, invoice_id, cc_num, cc_exp_date, result, created_at, updated_at)
    @id = id
    @invoice_id = invoice_id
    @credit_card_number = cc_num
    @credit_card_expiration_date = cc_exp_date
    @result = result
    @created_at = created_at
    @updated_at = updated_at
  end
end
