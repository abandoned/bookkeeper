module AccountsHelper
  def account_title
    ret = ""
    for parent in resource.ancestors.reverse
      ret << link_to(h(parent.name), parent) + " &gt; " 
    end
    ret + h(resource.name)
  end
  
  def tree_ul(collection, init=true, &block)
    haml_tag :ul do
      collection.collect do |parent|
        next if parent.parent_id && init
        haml_tag :li do
          haml_concat(yield(parent))
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
  
  def tree_select(categories, model, name, selected=nil, level=0, init=true, msg="Select parent account")
    if init
      haml_tag :select, {:name => "#{model}[#{name}]", :id => "#{model}_#{name}"} do
        haml_tag :option, msg
        tree_select(categories, model, name, selected, level, false)
      end
    else
      if categories.length > 0
        level += 1 # keep position
        categories.collect do |cat|
          next if !selected.nil? && cat.id == selected.id # skip self
          attributes = {:value => cat.id}
          attributes[:selected] = "selected" if !selected.nil? && cat.id == selected.parent_id
          haml_tag :option, :<, attributes do
            indent = ""
            if cat.parent
              (cat.ancestors.size * 3).times {indent << "&nbsp;"}
            end
            haml_concat(indent + cat.name)
          end
          tree_select(cat.children, model, name, selected, level, false)
        end
      end
    end
  end
end
