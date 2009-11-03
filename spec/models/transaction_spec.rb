# == Schema Information
#
# Table name: transactions
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
#  account_id    :integer
#  match_id :integer
#  created_at           :datetime
#  updated_at           :datetime
#

require 'spec_helper'

describe Transaction do
  before(:each) do
    @account = Factory(:account)
    @sender = Factory(:person)
    @recipient = Factory(:person)
    @transaction = Factory(:transaction,
                           :sender => @sender,
                           :recipient => @recipient,
                           :total_amount => 20.0,
                           :account => @account)
  end
  
  it "should belong to a account" do
    @transaction.account = nil
    lambda { @transaction.save! }.should raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "should not have a tax amount that exceeds the total amount" do
    @transaction.tax_amount = 21
    lambda { @transaction.save! }.should raise_error(ActiveRecord::RecordInvalid)
  end
end
