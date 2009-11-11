class Cart
  def ledger_items
    @ledger_items ||= []
  end
  
  def add(ledger_item)
    self.ledger_items << ledger_item unless ledger_item.matched? || self.ledger_items.include?(ledger_item)
  end
  
  def balance
    self.ledger_items.sum{ |t| t.total_amount }
  end
  
  def reconciled?
    self.balance == 0
  end
end