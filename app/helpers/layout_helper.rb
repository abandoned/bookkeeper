module LayoutHelper
  def title(page_title)
    @title = page_title.to_s
  end
  
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end
  
  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
  
  def navigation_links
    count = 0
    
    [
      { :text => 'Accounts',      :path => accounts_path,     :controller => 'accounts' },
      { :text => 'Transactions',  :path => ledger_items_path, :controller => 'ledger_items' },
      { :text => 'Contacts',      :path => contacts_path,     :controller => 'contacts' },
      { :text => 'Imports',       :path => imports_path,      :controller => 'imports' },
      { :text => 'Reports',       :path => report_path('income-statement'),       :controller => 'reports' },
    ].each do |link|
      
      classes = []
      classes << "active" if controller.controller_name == link[:controller]
      classes << "first" if count == 0
      
      count += 1
      
      haml_tag :li, :class => classes.join(" ") do
        haml_concat link_to(link[:text], link[:path])
      end
    end
  end
end
