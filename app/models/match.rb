# == Schema Information
#
# Table name: matches
#
#  id         :integer         not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

class Match < ActiveRecord::Base
  has_many :transactions
  
  def reconciled?
    self.transactions.inject(0) { |sum, i| sum + i.total_amount } == 0 ? true : false
  end
end
