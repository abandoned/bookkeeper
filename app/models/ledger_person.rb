# == Schema Information
#
# Table name: ledger_people
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

class LedgerPerson < ActiveRecord::Base
  has_many :sent_ledger_items,
           :class_name => "LedgerItem",
           :foreign_key => "sender_id"
  has_many :received_ledger_items,
           :class_name => "LedgerItem",
           :foreign_key => "recipient_id"
  before_destroy :may_not_have_sent_or_received_ledger_items
  
  protected
  
  def may_not_have_sent_or_received_ledger_items
    if self.received_ledger_items.size > 0 || self.sent_ledger_items.size > 0
      raise ActiveRecord::RecordNotDestroyed
    end
  end
end
