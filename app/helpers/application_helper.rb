# Methods added to this helper will be available to all templates in the application.

module ApplicationHelper
  def nav_links
    if current_user
      [{ :name => "Transactions",  :path => transactions_path },
       { :name => "Accounts",      :path => accounts_path },
       { :name => "People",        :path => people_path },
       { :name => "Reports",       :path => "/not-done-yet.html" },
       { :name => "Log out",       :path => logout_path }]
    else
      [{ :name => "Log in",    :path => login_path }]
    end
  end
end
