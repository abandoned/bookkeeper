module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name)
    case page_name
    
    when /the home\s?page/
      '/'
    
    # Add more mappings here.
    # Here is a more fancy example:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))
    when /the login page/
      login_path
    
    when /the list of ledger ([^ ]+)$/
      eval("ledger_#{$1}_path")
    
    when /^the (.*) ledger ([^ ]+) page$/
      eval("ledger_#{$2}_path(Ledger#{$2.capitalize}.find_by_name(\"#{$1}\"))")
      
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
