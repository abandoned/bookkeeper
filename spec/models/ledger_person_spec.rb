# == Schema Information
#
# Table name: ledger_people
#
#  id           :integer         not null, primary key
#  is_self      :boolean
#  name         :string(255)
#  contact_name :string(255)
#  address      :text
#  city         :string(255)
#  state        :string(255)
#  postal_code  :string(255)
#  country      :string(255)
#  country_code :string(2)
#  tax_number   :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe LedgerPerson do
  before(:each) do
    @ledger_account = Factory(:ledger_account)
    @sender = Factory(:ledger_person)
    @recipient = Factory(:ledger_person)
    @ledger_item = Factory(:ledger_item,
                           :sender => @sender,
                           :recipient => @recipient,
                           :ledger_account => @ledger_account,
                           :total_amount => 10,
                           :currency => "USD")
  end

  it "should not destroy if he has sent ledger items" do
    lambda {@sender.destroy}.should raise_error(ActiveRecord::RecordNotDestroyed)
  end
  
  it "should not destroy if he has received ledger items" do
    lambda {@sender.destroy}.should raise_error(ActiveRecord::RecordNotDestroyed)
  end
  
  it "should destroy if has no sent ledger items" do
    @ledger_item.destroy
    @sender.destroy
    lambda {LedgerPerson.find(@sender.id).should be_nil}.should raise_error(ActiveRecord::RecordNotFound)
  end
end
