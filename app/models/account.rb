# == Schema Information
#
# Table name: accounts
#
#  id         :integer         not null, primary key
#  ancestry   :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Account < ActiveRecord::Base
  acts_as_tree :orphan_strategy => :restrict
  has_many :ledger_items
  has_many :rules
  validates_uniqueness_of :name
  validates_presence_of :name
  before_destroy :do_not_orphan_ledger_items
  
  protected
  
  def do_not_orphan_ledger_items
    raise ActiveRecord::RecordNotDestroyed if self.ledger_items.size > 0
  end
end
