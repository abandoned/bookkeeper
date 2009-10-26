# == Schema Information
#
# Table name: ledger_item_groups
#
#  id         :integer         not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe LedgerItemGroup do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    LedgerItemGroup.create!(@valid_attributes)
  end
end
