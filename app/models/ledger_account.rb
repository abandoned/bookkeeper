# == Schema Information
#
# Table name: ledger_accounts
#
#  id         :integer         not null, primary key
#  parent_id  :integer
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class LedgerAccount < ActiveRecord::Base
  acts_as_tree
  has_many :ledger_items
  validates_uniqueness_of :name,
                          :scope => :parent_id
  validate_on_update :may_not_bear_itself,
                     :may_not_descend_from_descendants
  validate :parent_must_exist_and_not_have_ledger_items
  before_destroy :may_not_be_root_or_have_children
  
  def descendants
    (self.children + self.children.collect { |child| child.descendants }).flatten
  end
  
  def ancestor
    self.parent.nil? ? self : self.parent.ancestor
  end
  
  protected
  
  def may_not_be_root_or_have_children
    unless self.parent && self.children.size == 0
      raise ActiveRecord::RecordNotDestroyed
    end
  end
  
  def may_not_bear_itself
    if self.id == self.parent_id
      errors.add(:parent, "cannot be self")
    end
  end
  
  def may_not_descend_from_descendants
    if self.descendants.collect{ |e| e.id }.include?(self.parent_id)
      errors.add(:parent, "cannot bear its own descendant")
    end
  end
  
  def parent_must_exist_and_not_have_ledger_items
    if !self.parent_id.nil?
      if self.parent.nil?
        errors.add(:parent, "does not exist")
      elsif self.parent.ledger_items.count > 0
        errors.add(:parent, "may not bear child")
      end
    end
  end
end
