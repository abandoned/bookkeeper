# Methods added to this helper will be available to all templates in the application.

module ApplicationHelper
  def nav_links
    if current_user
      [{ :name => "Ledger Items",  :path => ledger_items_path },
       { :name => "Accounts",      :path => accounts_path },
       { :name => "People",        :path => people_path },
       { :name => "Reports",       :path => reports_path },
       { :name => "Log out",       :path => logout_path }]
    else
      [{ :name => "Log in",        :path => new_user_session_path }]
    end
  end
end
