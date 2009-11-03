class Cart
  def transactions
    @transactions ||= []
  end
  
  def add(transaction)
    self.transactions << transaction unless transaction.matched? || self.transactions.include?(transaction)
  end
  
  def balance
    self.transactions.sum{ |t| t.total_amount }
  end
  
  def reconciled?
    self.balance == 0
  end
end