if VERSION == '1.8.6'
  class Array
    alias_method :count, :size
  end
end