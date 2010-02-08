module AccountsHelper
  def account_ancestry
    ret = ''
    resource.ancestors.each do |parent|
      ret << link_to(h(parent.name), parent) + ' &gt; ' 
    end
    ret.chomp(' &gt; ').html_safe!
  end
  
  def tree_ul(collection, init=true, &block)
    content_tag :ul do
      collection.collect do |parent|
        next if parent.parent_id && init
        content_tag :li do
          yield(parent) +
          tree_ul(parent.children, false, &block) 
        end
      end
    end
  end
  
  def account_select(categories, selected=nil, level=0, init=true)
    if init
      haml_tag :select, {:name => "account", :id => "account", :class => "autocomplete"} do
        haml_tag :option, "All accounts", :value => ""
        account_select(categories, selected, level, false)
      end
    else
      if categories.length > 0
        level += 1 # keep position
        categories.collect do |cat|
          attributes = {:value => cat.id}
          attributes[:selected] = "selected" if !selected.nil? && cat.id == selected.id
          haml_tag :option, :<, attributes do
            indent = ""
            if cat.parent
              (cat.ancestors.size * 3).times {indent << "&nbsp;"}
            end
            haml_concat(indent + cat.name)
          end
          account_select(cat.children, selected, level, false)
        end
      end
    end
  end
  
  def tree_select(categories, model, name, selected=nil, level=0, init=true)
    if init
      content_tag :select, {:name => "#{model}[#{name}]", :id => "#{model}_#{name}"} do
        tree_select(categories, model, name, selected, level, false)
      end
    else
      html = ''
      if categories.length > 0
        level += 1 # keep position
        categories.collect do |cat|
          next if !selected.nil? && cat.id == selected.id # skip self
          attributes = {:value => cat.id}
          attributes[:selected] = "selected" if !selected.nil? && cat.id == selected.parent_id
          html << content_tag(:option, attributes) do
            indent = ''
            if cat.parent
              (cat.ancestors.size * 3).times {indent << "&nbsp;"}
            end
            indent + cat.name
          end
          html << tree_select(cat.children, model, name, selected, level, false)
        end
      end
      html
    end
  end
end
