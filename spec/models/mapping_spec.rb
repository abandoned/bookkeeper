# == Schema Information
#
# Table name: mappings
#
#  id                     :integer         not null, primary key
#  name                   :string(255)
#  currency               :string(3)
#  date_row               :integer
#  total_amount_row       :integer
#  tax_amount_row         :integer
#  description_row        :integer
#  second_description_row :integer
#  identifier_row         :integer
#  has_title_row          :boolean
#  day_follows_month      :boolean
#  created_at             :datetime
#  updated_at             :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mapping do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Mapping.create!(@valid_attributes)
  end
end
