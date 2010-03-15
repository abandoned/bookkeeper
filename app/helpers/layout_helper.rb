module LayoutHelper
  def title(page_title)
    @content_for_title = page_title.to_s
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
