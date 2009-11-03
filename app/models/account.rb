# == Schema Information
#
# Table name: accounts
#
#  id         :integer         not null, primary key
#  parent_id  :integer
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Account < ActiveRecord::Base
  acts_as_tree
  has_many :transactions
  has_many :rules
  validates_uniqueness_of :name,
                          :scope => :parent_id
  validates_presence_of :name
  validate_on_update :may_not_bear_itself,
                     :may_not_descend_from_descendants
  validate :if_associated_parent_must_exist
  before_destroy :may_not_destroy_if_it_is_root_or_has_children,
                 :may_not_destroy_if_it_has_transactions
  
  def descendants
    (self.children + self.children.collect { |child| child.descendants }).flatten
  end
  
  def ancestor
    self.parent.nil? ? self : self.parent.ancestor
  end
  
  protected
  
  def may_not_destroy_if_it_is_root_or_has_children
    unless self.parent && self.children.size == 0
      raise ActiveRecord::RecordNotDestroyed
    end
  end
  
  def may_not_destroy_if_it_has_transactions
    unless self.transactions.size == 0
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
  
  def if_associated_parent_must_exist
    if !self.parent_id.nil? && self.parent.nil?
      errors.add(:parent, "does not exist")
    end
  end
end
