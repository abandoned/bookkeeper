require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Match do
  before(:each) do
    @debit_account = Factory(:account)
    @credit_account = Factory(:account)
    @sender = Factory(:contact, :self => true)
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

  it "reconciles if sum of totals of matched ledger items is 0" do
    @match.reconciled?.should be_true
  end

  it "does not validate if not reconciled" do
    @debit_ledger_item.total_amount = 10.0
    @match.should_not be_valid
  end

  it "does not validate if matched ledger items have different currency" do
    @debit_ledger_item.currency = 'JPY'
    @match.should_not be_valid
  end

  it "does not validate if matched ledger items do not have same date" do
    @debit_ledger_item.transacted_on ="2010-01-01"
    @match.should_not be_valid
  end

  it "does not validate if matched ledger items have different selves" do
    @another_self = Factory(:contact, :self => true)
    @debit_ledger_item.recipient = @another_self
    @match.should_not be_valid
  end
end
