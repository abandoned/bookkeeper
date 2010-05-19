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
  
  describe "when destroyed" do
    it "should destroy associated rules" do
      contact = Factory(:contact)
      
      2.times { Factory(:rule_with_matched_description, :new_sender => contact) }
      2.times { Factory(:rule_with_matched_description, :new_recipient => contact) }
      2.times { Factory(:rule_with_matched_contact, :matched_sender => contact) }
      2.times { Factory(:rule_with_matched_contact, :matched_recipient => contact) }
      contact.destroy
      Rule.count.should eql(0)
    end
  end
end
