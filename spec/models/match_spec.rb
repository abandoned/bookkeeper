# == Schema Information
#
# Table name: matches
#
#  id         :integer         not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Match do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Match.create!(@valid_attributes)
  end
end
