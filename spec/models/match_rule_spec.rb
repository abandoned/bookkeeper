# == Schema Information
#
# Table name: match_rules
#
#  id                         :integer         not null, primary key
#  sender_id                  :integer
#  recipient_id               :integer
#  ledger_account_id          :integer
#  matching_ledger_account_id :integer
#  description_matcher        :string(255)
#  debit                      :boolean
#  created_at                 :datetime
#  updated_at                 :datetime
#

require 'spec_helper'

describe MatchRule do
  before(:each) do
    @ledger_account = Factory(:ledger_account)
    @matching_ledger_account = Factory(:ledger_account)
    @sender = Factory(:ledger_person)
    @recipient = Factory(:ledger_person)
    @ledger_item = Factory(:ledger_item,
                           :total_amount => 20,
                           :description => "Foo bar baz",
                           :ledger_account => @ledger_account)
  end
  
  it "should update a matching ledger item" do
    @match_rule = Factory(:match_rule,
                          :description_matcher => "[a-c]ar",
                          :debit => true,
                          :sender => @sender,
                          :recipient => @recipient,
                          :ledger_account => @ledger_account,
                          :matching_ledger_account => @matching_ledger_account)
    @ledger_item = LedgerItem.find @ledger_item.id
    @ledger_item.sender.should == @sender
    @ledger_item.recipient.should == @recipient
    @last_ledger_item = LedgerItem.last
    @last_ledger_item.sender.should == @recipient
    @last_ledger_item.recipient.should == @sender
    @last_ledger_item.ledger_account.should == @matching_ledger_account
    @last_ledger_item.total_amount.should == @ledger_item.total_amount * -1.0
    @ledger_item.matched?.should be_true
  end
  
  it "should not update a ledger item when debit rule matches but description does not" do
    @match_rule = Factory(:match_rule,
                          :description_matcher => "[cde]ar",
                          :debit => true,
                          :sender => @sender,
                          :recipient => @recipient,
                          :ledger_account => @ledger_account,
                          :matching_ledger_account => @matching_ledger_account)
    @ledger_item = LedgerItem.find @ledger_item.id
    @ledger_item.sender.should be_nil
  end
  
  it "should not update a ledger item when description matches but debit rule does not" do
    @match_rule = Factory(:match_rule,
                          :description_matcher => "[a-c]ar",
                          :debit => false,
                          :sender => @sender,
                          :recipient => @recipient,
                          :ledger_account => @ledger_account,
                          :matching_ledger_account => @matching_ledger_account)
    @ledger_item = LedgerItem.find @ledger_item.id
    @ledger_item.sender.should be_nil
  end
end
