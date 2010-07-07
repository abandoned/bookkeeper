class RetainedIncome
  class << self
    def children
      nil
    end
  
    def grand_total_for?(*args)
      true
    end

    def depth
      1
    end

    def name
      "Retained Income"
    end

    def total_for?(*args)
      true
    end

    def total_for_in_base_currency(perspective, from_date, to_date, base_currency, base_currency_date)
      roots = AssetOrLiability.roots + Equity.roots
      -1 * roots.sum do |a|
        a.grand_total_for_in_base_currency(perspective, from_date, to_date, base_currency, base_currency_date)
      end
    end
  end
end
