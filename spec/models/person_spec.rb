# == Schema Information
#
# Table name: people
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

describe Person do
  before(:each) do
    @account = Factory(:account)
    @sender = Factory(:person)
    @recipient = Factory(:person)
    @transaction = Factory(:transaction,
                           :sender => @sender,
                           :recipient => @recipient,
                           :account => @account,
                           :total_amount => 10,
                           :currency => "USD")
  end

  it "should not destroy if he has sent transactions" do
    lambda {@sender.destroy}.should raise_error(ActiveRecord::RecordNotDestroyed)
  end
  
  it "should not destroy if he has received transactions" do
    lambda {@sender.destroy}.should raise_error(ActiveRecord::RecordNotDestroyed)
  end
  
  it "should destroy if has no sent transactions" do
    @transaction.destroy
    @sender.destroy
    lambda {Person.find(@sender.id).should be_nil}.should raise_error(ActiveRecord::RecordNotFound)
  end
end
