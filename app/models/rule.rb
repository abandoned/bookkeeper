# == Schema Information
#
# Table name: rules
#
#  id                         :integer         not null, primary key
#  sender_id                  :integer
#  recipient_id               :integer
#  account_id          :integer
#  matching_account_id :integer
#  description_matcher        :string(255)
#  debit                      :boolean
#  created_at                 :datetime
#  updated_at                 :datetime
#

class Rule < ActiveRecord::Base
  belongs_to :account
  belongs_to :sender, :class_name => "Person"
  belongs_to :recipient, :class_name => "Person"
  belongs_to :matching_account, :class_name => "Account"
  validates_associated :sender, :recipient, :account, :matching_account
  validates_presence_of :sender, :recipient, :account, :matching_account
  after_save :match_transactions
  
  def match_transactions
    self.account.transactions.unmatched.each { |i| self.match(i) }
  end
  
  def match(transaction)
    mlt = self.debit? ? 1 : -1
    regexp = Regexp.new(self.description_matcher, true)
    if !transaction.matched? && transaction.description =~ regexp && transaction.total_amount * mlt > 0
      matched_transaction = Transaction.create!(:sender_id => self.recipient_id,
                                        :recipient_id => self.sender_id,
                                        :issued_on => transaction.issued_on,
                                        :total_amount => transaction.total_amount * -1.0,
                                        :currency => transaction.currency,
                                        :account_id => self.matching_account_id)
      group = Match.create!
      group.transactions << [transaction, matched_transaction]
      transaction.update_attributes!(:sender_id => self.sender_id,
                              :recipient_id => self.recipient_id)
    else
      false
    end
  end
end
