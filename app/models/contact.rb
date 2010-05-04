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
  
  before_destroy :cannot_orphan_ledger_items
  after_destroy  :destroy_associated_rules
  
  named_scope :self, :conditions => ["self = ?", true]
  
  protected
  
  def cannot_orphan_ledger_items
    if self.received_ledger_items.size > 0 || self.sent_ledger_items.size > 0
      raise ActiveRecord::RecordNotDestroyed
    end
  end
  
  def destroy_associated_rules
    Rule.destroy_all(:new_sender_id => id)
    Rule.destroy_all(:new_recipient_id => id)
    Rule.destroy_all(:matched_sender_id => id)
    Rule.destroy_all(:matched_recipient_id => id)
  end
end
