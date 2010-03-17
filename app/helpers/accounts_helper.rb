module AccountsHelper
  def tree_ul(collection, init=true, &block)
    attributes = init ? { :class => 'root' } : {}
    
    haml_tag :ul, attributes do
      collection.collect do |parent|
        next if parent.parent_id && init
        
        haml_tag :li do
          haml_concat yield(parent)
          tree_ul parent.children, false, &block
        end
      end
    end
  end
  
  def ancestry_breadcrumbs(resource)
    last_index = resource.ancestors.size - 1
    ancestors = resource.ancestors
    
    ancestors.each_index do |i|
      parent = ancestors[i]
      separator = (i != last_index ? ' &gt; ' : '')
      breadcrump = link_to parent.name, parent
      haml_concat (breadcrump + separator).html_safe!
    end
  end
  
  def tree_select(categories, model, name, selected=nil, level=0, init=true)
    if init  
      haml_tag :select, {:name => "#{model}[#{name}]", :id => "#{model}_#{name}"} do
        tree_select(categories, model, name, selected, level, false)
      end
    else
      if categories.length > 0
        level += 1 # keep position
        categories.collect do |cat|
          next if selected && cat.id == selected.id # Skip self
          
          attributes = {:value => cat.id}
          if selected && cat.id == selected.parent_id
            attributes[:selected] = 'selected'
          end
          
          haml_tag :option, attributes do
            indent = ''
            if cat.parent
              (cat.ancestors.size * 3).times {indent << "&nbsp;"}
            end
            haml_concat indent + cat.name
          end
          
          tree_select cat.children, model, name, selected, level, false
        end
      end
    end
  end
end
