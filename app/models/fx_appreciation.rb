class FxAppreciation
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
      "Appreciation in Value of Foreign-Currency-Valued Assets and Liabilities"
    end

    def total_for?(*args)
      true
    end

    def total_for_in_base_currency(perspective, from_date, to_date, base_currency, base_currency_date)
      roots = RevenueOrExpense.roots.all
      sum_current = roots.sum do |a|
        a.grand_total_for_in_base_currency(perspective, "1990-01-01", Date.parse(from_date.to_s) - 1, base_currency, base_currency_date)
      end
      sum_orig = roots.sum do |a|
        a.grand_total_for_in_base_currency(perspective, "1990-01-01", Date.parse(from_date.to_s) - 1, base_currency, (Date.parse(from_date) - 1))
      end
      sum_current - sum_orig
    end
  end
end
