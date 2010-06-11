module LedgerItemsHelper
  
  # A little wrapper around the number_to_currency helper to display negative
  # entries in a pretty manner.
  def monetize(amount, currency)
    symbol = LedgerItem::CURRENCY_SYMBOLS[currency]

    if amount < 0
      sign = content_tag(:strong, "CR ")
      amount *= -1
    else
      sign = ""
    end
    if currency == 'JPY'
      sign + number_to_currency(amount.to_s, :unit => symbol, :format => "%u%n", :precision => 0)
    else
      sign + number_to_currency(amount.to_s, :unit => symbol, :format => "%u%n")
    end
  end
  
  def hamlified_tree_select(categories, model, name, selected=nil, prompt=true, level=0, init=true)
    if init
      haml_tag :select, {:name => "#{model}[#{name}]", :id => "#{model}_#{name}"} do
        if prompt
          prompt = "Select #{categories.first.class.to_s.humanize.downcase}" if prompt == true
          haml_tag :option, prompt, :value => ""
        end
        hamlified_tree_select(categories, model, name, selected, nil, level, false)
      end
    else
      level += 1 # keep position
      categories.collect do |category|
        attributes = {:value => category.id}
        attributes[:selected] = "selected" if selected && category.id == selected.id
        haml_tag :option, category.name, attributes
        if category.children
          hamlified_tree_select(category.children, model, name, selected, nil, level, false)
        end
      end
    end
  end
  
  def grouped_tree_select(categories, model, name, selected=nil, prompt=true, level=0, init=true)
    if init
      haml_tag :select, {:name => "#{model}[#{name}]", :id => "#{model}_#{name}"} do
        if prompt
          prompt = "Select #{categories.first.class.to_s.humanize.downcase}" if prompt == true
          content_tag:option, prompt, :value => ''
        end
        grouped_tree_select(categories, model, name, selected, nil, level, false)
      end
    else
      level += 1 # keep position
      categories.each do |category|
        if level == 1
          haml_tag :optgroup, { :label => category.name } do
            if category.children
              grouped_tree_select(category.children, model, name, selected, nil, level, false)
            end
          end
        else
          attributes = {:value => category.id}
          attributes[:selected] = "selected" if selected && category.id == selected.id
          haml_tag(:option, category.name, attributes)
          if category.children
            grouped_tree_select(category.children, model, name, selected, nil, level, false).to_s
          end
        end
      end
    end
  end
  
  def params_to_date(param)
    return nil if param.blank? || param[:year].blank? || param[:month].blank? || param[:day].blank?
    Date.new(param[:year].to_i, param[:month].to_i, param[:day].to_i)
  end
  
  def data_for_obese_autocomplete
    content_for :head do
      javascript_tag do
        "var data = { 'by': [#{Contact.self.all.inject('') {|m, i| m = m + ', ' unless m.blank?; m + "'#{escape_javascript(i.name)}'"}}], 'through': [#{Contact.all(:order => 'name ASC').inject('') {|m, i| m = m + ', ' unless m.blank?; m + "'#{escape_javascript(i.name)}'"}}], 'in': [#{Account.all(:order => 'name ASC').inject('') {|m, i| m = m + ', ' unless m.blank?; m + "'#{escape_javascript(i.name)}'"}}] };".html_safe
      end
    end
  end
end
