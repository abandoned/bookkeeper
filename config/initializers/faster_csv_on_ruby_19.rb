if RUBY_VERSION.include?("1.9")
  require "csv"  
  unless defined? FasterCSV
   class Object  
     FasterCSV = CSV 
     alias_method :FasterCSV, :CSV
   end
  end
else
  require "fastercsv"
end
