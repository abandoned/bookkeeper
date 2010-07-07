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
      
      roots = RevenueOrExpense.roots + CurrencyConversion.roots
      income_in_period = roots.sum do |a|
        a.grand_total_for_in_base_currency(perspective, from_date, to_date, base_currency, base_currency_date)
      end
      retained_income = RetainedIncome.total_for_in_base_currency(perspective, from_date, to_date, base_currency, base_currency_date)
      retained_income - income_in_period
    end
  end
end
