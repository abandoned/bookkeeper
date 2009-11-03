# == Schema Information
#
# Table name: people
#
#  id           :integer         not null, primary key
#  is_self      :boolean
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
#

class Person < ActiveRecord::Base
  has_many :sent_transactions,
           :class_name => "Transaction",
           :foreign_key => "sender_id"
  has_many :received_transactions,
           :class_name => "Transaction",
           :foreign_key => "recipient_id"
  before_destroy :may_not_have_sent_or_received_transactions
  named_scope :self, :conditions => ["is_self = ?", true]
  
  protected
  
  def may_not_have_sent_or_received_transactions
    if self.received_transactions.size > 0 || self.sent_transactions.size > 0
      raise ActiveRecord::RecordNotDestroyed
    end
  end
end
