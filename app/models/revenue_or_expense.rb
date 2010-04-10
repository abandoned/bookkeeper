# == Schema Information
#
# Table name: accounts
#
#  id         :integer         not null, primary key
#  ancestry   :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  type       :string(255)
#
# Indexes
#
#  index_accounts_on_type      (type)
#  index_accounts_on_ancestry  (ancestry)
#

class RevenueOrExpense < Account
end
