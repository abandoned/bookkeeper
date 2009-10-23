Factory.define :user do |f|
  f.sequence(:login) { |n| "jdoe#{n}" }
  f.sequence(:email) { |n| "jdoe#{n}@example.com" }
  f.password "secret"
  f.password_confirmation { |u| u.password }
  f.sequence(:persistence_token) { |n| "#{n}" }
end

Factory.define :ledger_account do |f|
  f.sequence(:name) { |n| "foo#{n}" }
end

Factory.define :ledger_person do |f|
  f.sequence(:name) { |n| "foo#{n}" }
end

Factory.define :ledger_item do |f|
  f.issued_on { Date.today }
  f.total_amount 10
  f.currency "USD"
end