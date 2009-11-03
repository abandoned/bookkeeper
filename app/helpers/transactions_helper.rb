module TransactionsHelper
  
  # A little wrapper around the number_to_currency helper to display negative
  # entries in a pretty manner.
  def monetize(amount, symbol)
    if amount < 0
      sign = "- "
      amount *= -1
    else
      sign = ""
    end
    sign + number_to_currency(amount, :unit => symbol, :format => "%u%n")
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
  
  def hamlified_grouped_tree_select(categories, model, name, selected=nil, prompt=true, level=0, init=true)
    if init
      haml_tag :select, {:name => "#{model}[#{name}]", :id => "#{model}_#{name}"} do
        if prompt
          prompt = "Select #{categories.first.class.to_s.humanize.downcase}" if prompt == true
          haml_tag :option, prompt, :value => ""
        end
        hamlified_grouped_tree_select(categories, model, name, selected, nil, level, false)
      end
    else
      level += 1 # keep position
      categories.collect do |category|
        if level == 1
          haml_tag :optgroup, { :label => category.name } do
            if category.children
              hamlified_grouped_tree_select(category.children, model, name, selected, nil, level, false)
            end
          end
        else
          attributes = {:value => category.id}
          attributes[:selected] = "selected" if selected && category.id == selected.id
          haml_tag :option, category.name, attributes
          if category.children
            hamlified_grouped_tree_select(category.children, model, name, selected, nil, level, false)
          end
        end
      end
    end
  end
end
