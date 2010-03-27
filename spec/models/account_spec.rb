require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Account do
  before(:each) do
    @parent = Factory(:account)
    @child = Factory(:account, :parent => @parent)
  end
  
  it "should not descend from itself" do
    @parent.parent = @parent
    lambda {@parent.save!}.should raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "should not descend from its descendants" do
    @parent.parent = @child
    lambda {@parent.save!}.should raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "should not come into being if parent is not found" do
    lambda {Factory(:account, :parent_id => 0)}.should raise_error(ActiveRecord::RecordNotFound)
  end
  
  it "should not orphan children" do
    lambda {@parent.destroy}.should raise_error(Ancestry::AncestryException)
  end
  
  it "should not orphan ledger items" do
    ledger_item = Factory(:ledger_item,
                          :account => @child)
    lambda {@child.destroy}.should raise_error(ActiveRecord::RecordNotDestroyed)
  end
  
  it "should not have a blank name" do
    @parent.name = ""
    lambda {@parent.save!}.should raise_error(ActiveRecord::RecordInvalid)
  end
end

# == Schema Information
#
# Table name: accounts
#
#  id         :integer         not null, primary key
#  ancestry   :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  type       :string(255)
#

