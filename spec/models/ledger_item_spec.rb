# == Schema Information
#
# Table name: ledger_items
#
#  id                   :integer         not null, primary key
#  sender_id            :integer
#  recipient_id         :integer
#  issued_on            :date
#  total_amount         :decimal(20, 4)
#  tax_amount           :decimal(20, 4)
#  currency             :string(3)       not null
#  description          :string(255)
#  identifier           :string(255)
#  ledger_account_id    :integer
#  ledger_item_group_id :integer
#  created_at           :datetime
#  updated_at           :datetime
#

require 'spec_helper'

describe LedgerItem do
  before(:each) do
    @ledger_account = Factory(:ledger_account)
    @sender = Factory(:ledger_person)
    @recipient = Factory(:ledger_person)
    @ledger_item = Factory(:ledger_item,
                           :sender => @sender,
                           :recipient => @recipient,
                           :ledger_account => @ledger_account)
  end
  
  it "should have a sender" do
    @ledger_item.sender = nil
    lambda { @ledger_item.save! }.should raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "should have a recipient" do
    @ledger_item.recipient = nil
    lambda { @ledger_item.save! }.should raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "should belong to a ledger account" do
    @ledger_item.ledger_account = nil
    lambda { @ledger_item.save! }.should raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "should not have a tax amount that exceeds the total amount" do
    @ledger_item.tax_amount = 11
    lambda { @ledger_item.save! }.should raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "should not belong to a ledger account that has children" do
    @parent = Factory(:ledger_account)
    @child = Factory(:ledger_account, :parent => @parent)
    lambda { ledger_item = Factory(:ledger_item,
                          :sender => @sender,
                          :recipient => @recipient,
                          :ledger_account => @parent) }.should raise_error(ActiveRecord::RecordInvalid)
  end
end
