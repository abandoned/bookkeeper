# http://gist.github.com/162881
require 'action_controller/test_process'
Factory.class_eval do
  def attachment(name, path, content_type = nil)
    path_with_rails_root = "#{RAILS_ROOT}/#{path}"
    uploaded_file = if content_type
                      ActionController::TestUploadedFile.new(path_with_rails_root, content_type)
                    else
                      ActionController::TestUploadedFile.new(path_with_rails_root)
                    end
 
    add_attribute name, uploaded_file
  end
end

Factory.define :user do |f|
  f.sequence(:login) { |n| "jdoe#{n}" }
  f.sequence(:email) { |n| "jdoe#{n}@example.com" }
  f.password 'secret'
  f.password_confirmation { |u| u.password }
  f.sequence(:persistence_token) { |n| "#{n}" }
end

Factory.define :account do |f|
  f.sequence(:name) { |n| "foo#{n}" }
end

Factory.define :contact do |f|
  f.sequence(:name) { |n| "foo#{n}" }
end

Factory.define :ledger_item do |f|
  f.transacted_on { Date.today }
  f.total_amount 10
  f.currency 'USD'
  f.association :account
end

Factory.define :match do |f|
end

Factory.define :mapping do |f|
end

Factory.define :import do |f|
  f.attachment(:file, 'spec/fixtures/citi-sample.csv', 'text/plain')
  f.ending_balance 0
  f.association :account
  f.association :mapping
  f.sequence(:file_name) { |n| "/tmp/foo#{n}.txt" }
  f.status 'pending'
end

Factory.define :assetOrLiability do |f|
  f.sequence(:name) { |n| "asset_or_liability#{n}" }
end

Factory.define :revenueOrExpense do |f|
  f.sequence(:name) { |n| "revenue_or_expense#{n}" }
end

Factory.define :rule do |f|
  f.association :account
  f.matched_debit false
end

Factory.define :rule_with_matched_description, :parent => :rule do |f|
  f.association :new_account, :factory => :account
  f.association :new_sender, :factory => :contact
  f.association :new_recipient, :factory => :contact
  f.matched_description 'foo'
end

Factory.define :rule_with_matched_contact, :parent => :rule do |f|
  f.association :new_account, :factory => :account
  f.association :matched_sender, :factory => :contact
  f.association :matched_recipient, :factory => :contact
end
