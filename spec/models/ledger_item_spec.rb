# == Schema Information
#
# Table name: ledger_items
#
#  id           :integer         not null, primary key
#  sender_id    :integer
#  recipient_id :integer
#  transacted_on    :date
#  total_amount :decimal(20, 4)
#  tax_amount   :decimal(20, 4)
#  currency     :string(3)       not null
#  description  :string(255)
#  identifier   :string(255)
#  account_id   :integer
#  match_id     :integer
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe LedgerItem do
  before(:each) do
    @account = Factory(:account)
    @sender = Factory(:person)
    @recipient = Factory(:person)
    @ledger_item = Factory(:ledger_item,
                           :sender => @sender,
                           :recipient => @recipient,
                           :total_amount => 20.0,
                           :account => @account)
  end
  
  it "should belong to a account" do
    @ledger_item.account = nil
    lambda { @ledger_item.save! }.should raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "should not have a tax amount that exceeds the total amount" do
    @ledger_item.tax_amount = 21
    lambda { @ledger_item.save! }.should raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "should have a valid currency code" do
    @ledger_item.currency = "ZZZ"
    lambda { @ledger_item.save! }.should raise_error(ActiveRecord::RecordInvalid)
  end
end
