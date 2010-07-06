require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Match do
  before(:each) do
    @debit_account = Factory(:account)
    @credit_account = Factory(:account)
    @sender = Factory(:contact)
    @recipient = Factory(:contact)
    @debit_ledger_item = Factory(:ledger_item,
                          :sender => @recipient,
                          :recipient => @sender,
                          :total_amount => 20.0,
                          :account => @debit_account,
                          :transacted_on => "2009-01-01")
    @credit_ledger_item = Factory(:ledger_item,
                           :sender => @sender,
                           :recipient => @recipient,
                           :total_amount => -20.0,
                           :account => @credit_account,
                           :transacted_on => "2009-01-01")
    @match = Match.new
    @match.ledger_items << @debit_ledger_item
    @match.ledger_items << @credit_ledger_item
  end

  it "does reconcile if sum of totals of matched ledger items is 0" do
    @match.reconciled?.should be_true
  end
  
  it "does not validate if not reconciled" do
    @debit_ledger_item.update_attribute :total_amount, 10.0
    lambda {@match.save!}.should raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "does not validate if matched ledger items have different currency" do
    @debit_ledger_item.update_attribute :currency, 'JPY'
    lambda {@match.save!}.should raise_error(ActiveRecord::RecordInvalid)
  end

  it "does not validate if matched items do not have same date" do
    @debit_ledger_item.update_attribute :transacted_on,"2010-01-01"
    lambda {@match.save!}.should raise_error(ActiveRecord::RecordInvalid)
  end
end
