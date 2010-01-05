# Methods added to this helper will be available to all templates in the application.

module ApplicationHelper
  def segmented_controls
    [
      { :text => 'Transactions',  :path => ledger_items_path },
      { :text => 'Accounts',      :path => accounts_path },
      { :text => 'Contacts',      :path => contacts_path },
      { :text => 'Reports',       :path => reports_path },
      { :text => 'Log out',       :path => logout_path },
    ]
  end
end
