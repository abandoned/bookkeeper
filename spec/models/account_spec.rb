# == Schema Information
#
# Table name: accounts
#
#  id         :integer         not null, primary key
#  parent_id  :integer
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Account do
  before(:each) do
    @parent = Factory(:account)
    @child = Factory(:account, :parent => @parent)
  end
  
  it "should not be its own parent" do
    @parent.parent = @parent
    lambda {@parent.save!}.should raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "should not descend from its progeny" do
    @parent.parent = @child
    lambda {@parent.save!}.should raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "should not create if parent is invalid" do
    lambda {Factory(:account, :parent_id => 0)}.should raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "should destroy if it has no children" do
    @child.destroy
    @child.frozen?.should === true
  end
  
  it "should not destroy if it has children" do
    lambda {@parent.destroy}.should raise_error(ActiveRecord::RecordNotDestroyed)
  end
  
  it "should not destroy if it has transactions" do
    sender = Factory(:person)
    recipient = Factory(:person)
    transaction = Factory(:transaction,
                          :sender => sender,
                          :recipient => recipient,
                          :account => @child)
    lambda {@child.destroy}.should raise_error(ActiveRecord::RecordNotDestroyed)
  end
end
