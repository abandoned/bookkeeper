# == Schema Information
#
# Table name: contacts
#
#  id           :integer         not null, primary key
#  self      :boolean
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

class Contact < ActiveRecord::Base
  has_many :sent_ledger_items,
           :class_name => "LedgerItem",
           :foreign_key => "sender_id"
  has_many :received_ledger_items,
           :class_name => "LedgerItem",
           :foreign_key => "recipient_id"
  
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create, :allow_blank => true
  
  before_destroy :may_not_orphan_ledger_items
  
  named_scope :self, :conditions => ["self = ?", true]
  
  protected
  
  def may_not_orphan_ledger_items
    if self.received_ledger_items.size > 0 || self.sent_ledger_items.size > 0
      raise ActiveRecord::RecordNotDestroyed
    end
  end
end
