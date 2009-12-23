# == Schema Information
#
# Table name: ledger_items
#
#  id            :integer         not null, primary key
#  sender_id     :integer
#  recipient_id  :integer
#  transacted_on :date
#  total_amount  :decimal(, )
#  tax_amount    :decimal(, )     default(0.0)
#  currency      :string(3)       not null
#  description   :string(255)
#  identifier    :string(255)
#  account_id    :integer
#  match_id      :integer
#  created_at    :datetime
#  updated_at    :datetime
#

require File.dirname(__FILE__) + '/../spec_helper'

describe LedgerItem do
  before(:each) do
    @account = Factory(:account)
    @sender = Factory(:contact)
    @recipient = Factory(:contact)
    @ledger_item = Factory(:ledger_item,
                           :sender => @sender,
                           :recipient => @recipient,
                           :total_amount => 20.0,
                           :account => @account,
                           :transacted_on => Date.new(2009,1,31))
  end
  
  it "should belong to a account" do
    @ledger_item.account = nil
    lambda { @ledger_item.save! }.should raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "should not have a tax amount that exceeds the total amount when transaction is a debit" do
    @ledger_item.tax_amount = 21
    lambda { @ledger_item.save! }.should raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "should not have a tax amount that exceeds the total amount when transaction is a credit" do
    @ledger_item.total_amount = -20
    @ledger_item.tax_amount = -21
    lambda { @ledger_item.save! }.should raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "should not have a tax amount that is the inverse sign of the total amount" do
    @ledger_item.tax_amount = -1
    lambda { @ledger_item.save! }.should raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "should have a valid currency code" do
    @ledger_item.currency = "ZZZ"
    lambda { @ledger_item.save! }.should raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "should validate if transaction is between selves" do
    @sender.self = true
    @sender.save
    @recipient.self = true
    @recipient.save
    lambda { @ledger_item.save! }.should_not raise_error
  end
  
  it "should validate if transacting parties are not defined" do
    @ledger_item.sender = nil
    @ledger_item.recipient = nil
    lambda { @ledger_item.save! }.should_not raise_error
  end
  
  it "should not validate if debit and not from perspective of self" do
    @sender.self = true
    @sender.save
    lambda { @ledger_item.save! }.should raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "should not validate if credit and not from perspective of self" do
    @recipient.self = true
    @recipient.save
    @ledger_item.total_amount = -20.0
    lambda { @ledger_item.save! }.should raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "should not total 0" do
    @ledger_item.total_amount = 0
    lambda { @ledger_item.save! }.should raise_error(ActiveRecord::RecordInvalid)
  end
  
  describe "date scope" do
    before(:each) do
      Factory(:ledger_item,
              :transacted_on => Date.new(2009, 1, 1))
    end
    
    it "should scope transaction date on or after a date object" do
      from = Date.new(2009, 1, 15)
      LedgerItem.from_date(from).size.should == 1
    end
    
    it "should scope transaction date on or after a date hash" do
      from = { :year => 2009,
               :month => 1,
               :day => 15
             }
      LedgerItem.from_date(from).size.should == 1
    end
    
    it "should scope transaction date on or before a date object" do
      to = Date.new(2009, 1, 15)
      LedgerItem.to_date(to).size.should == 1
    end
    
    it "should scope transaction date on or before a date hash" do
      to = { :year => 2009,
               :month => 1,
               :day => 15
             }
      LedgerItem.to_date(to).size.should == 1
    end
  end
end
