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
#  has_title_row          :boolean
#  day_follows_month      :boolean
#  reverses_sign          :boolean
#  created_at             :datetime
#  updated_at             :datetime
#

class Mapping < ActiveRecord::Base
  has_many :imports
end
