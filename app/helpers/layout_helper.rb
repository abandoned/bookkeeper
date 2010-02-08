# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  def title(page_title, show_title = true)
    @content_for_title = page_title.to_s
    @show_title = show_title
  end
  
  def show_title?
    @show_title
  end
  
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end
  
  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
  
  def navigation_links
    [
      { :text => 'Accounts',      :path => accounts_path,     :controller => 'accounts' },
      { :text => 'Contacts',      :path => contacts_path,     :controller => 'contacts' },
      { :text => 'Transactions',  :path => ledger_items_path, :controller => 'ledger_items' },
      { :text => 'Reports',       :path => reports_path,      :controller => 'reports' },
    ]
  end
end
