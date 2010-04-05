require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Contact do
  before(:each) do
    @account = Factory(:account)
    @sender = Factory(:contact)
    @recipient = Factory(:contact)
    @ledger_item = Factory(:ledger_item,
                           :sender => @sender,
                           :recipient => @recipient,
                           :account => @account,
                           :total_amount => 10,
                           :currency => "USD")
  end

  it "should not expire if he has sent ledger items" do
    lambda {@sender.destroy}.should raise_error(ActiveRecord::RecordNotDestroyed)
  end
  
  it "should not expire if he has received ledger items" do
    lambda {@sender.destroy}.should raise_error(ActiveRecord::RecordNotDestroyed)
  end
  
  it "should expire if has no sent ledger items" do
    @ledger_item.destroy
    @sender.destroy
    lambda {Contact.find(@sender.id)}.should raise_error(ActiveRecord::RecordNotFound)
  end
end

# == Schema Information
#
# Table name: contacts
#
#  id           :integer         not null, primary key
#  self         :boolean         default(FALSE)
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
#  email        :string(255)
#  phone_number :string(255)
#

