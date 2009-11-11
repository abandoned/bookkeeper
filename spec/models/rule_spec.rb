# == Schema Information
#
# Table name: rules
#
#  id                  :integer         not null, primary key
#  sender_id           :integer
#  recipient_id        :integer
#  account_id          :integer
#  matching_account_id :integer
#  regexp :string(255)
#  debit               :boolean
#  created_at          :datetime
#  updated_at          :datetime
#

require 'spec_helper'

describe Rule do
  before(:each) do
    @account = Factory(:account)
    @matching_account = Factory(:account)
    @sender = Factory(:person)
    @recipient = Factory(:person)
    @ledger_item = Factory(:ledger_item,
                           :total_amount => 20,
                           :description => "Foo bar baz",
                           :account => @account)
  end
  
  it "should update a matching ledger item" do
    @rule = Factory(:rule,
                          :regexp => "[a-c]ar",
                          :debit => true,
                          :sender => @sender,
                          :recipient => @recipient,
                          :account => @account,
                          :matching_account => @matching_account)
    @ledger_item = LedgerItem.find @ledger_item.id
    @ledger_item.sender.should == @sender
    @ledger_item.recipient.should == @recipient
    @last_ledger_item = LedgerItem.last
    @last_ledger_item.sender.should == @recipient
    @last_ledger_item.recipient.should == @sender
    @last_ledger_item.account.should == @matching_account
    @last_ledger_item.total_amount.should == @ledger_item.total_amount * -1.0
    @ledger_item.matched?.should be_true
  end
  
  it "should not update a ledger item when debit rule matches but description does not" do
    @rule = Factory(:rule,
                          :regexp => "[cde]ar",
                          :debit => true,
                          :sender => @sender,
                          :recipient => @recipient,
                          :account => @account,
                          :matching_account => @matching_account)
    @ledger_item = LedgerItem.find @ledger_item.id
    @ledger_item.sender.should be_nil
  end
  
  it "should not update a ledger item when description matches but debit rule does not" do
    @rule = Factory(:rule,
                          :regexp => "[a-c]ar",
                          :debit => false,
                          :sender => @sender,
                          :recipient => @recipient,
                          :account => @account,
                          :matching_account => @matching_account)
    @ledger_item = LedgerItem.find @ledger_item.id
    @ledger_item.sender.should be_nil
  end
end
