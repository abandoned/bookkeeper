# == Schema Information
#
# Table name: rules
#
#  id                         :integer         not null, primary key
#  sender_id                  :integer
#  recipient_id               :integer
#  account_id          :integer
#  matching_account_id :integer
#  description_matcher        :string(255)
#  debit                      :boolean
#  created_at                 :datetime
#  updated_at                 :datetime
#

require 'spec_helper'

describe Rule do
  before(:each) do
    @account = Factory(:account)
    @matching_account = Factory(:account)
    @sender = Factory(:person)
    @recipient = Factory(:person)
    @transaction = Factory(:transaction,
                           :total_amount => 20,
                           :description => "Foo bar baz",
                           :account => @account)
  end
  
  it "should update a matching transaction" do
    @rule = Factory(:rule,
                          :description_matcher => "[a-c]ar",
                          :debit => true,
                          :sender => @sender,
                          :recipient => @recipient,
                          :account => @account,
                          :matching_account => @matching_account)
    @transaction = Transaction.find @transaction.id
    @transaction.sender.should == @sender
    @transaction.recipient.should == @recipient
    @last_transaction = Transaction.last
    @last_transaction.sender.should == @recipient
    @last_transaction.recipient.should == @sender
    @last_transaction.account.should == @matching_account
    @last_transaction.total_amount.should == @transaction.total_amount * -1.0
    @transaction.matched?.should be_true
  end
  
  it "should not update a transaction when debit rule matches but description does not" do
    @rule = Factory(:rule,
                          :description_matcher => "[cde]ar",
                          :debit => true,
                          :sender => @sender,
                          :recipient => @recipient,
                          :account => @account,
                          :matching_account => @matching_account)
    @transaction = Transaction.find @transaction.id
    @transaction.sender.should be_nil
  end
  
  it "should not update a transaction when description matches but debit rule does not" do
    @rule = Factory(:rule,
                          :description_matcher => "[a-c]ar",
                          :debit => false,
                          :sender => @sender,
                          :recipient => @recipient,
                          :account => @account,
                          :matching_account => @matching_account)
    @transaction = Transaction.find @transaction.id
    @transaction.sender.should be_nil
  end
end
