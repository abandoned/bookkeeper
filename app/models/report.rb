class Report
  NAMES = ["Income Statement", "Balance Sheet"]

  attr_reader :name

  def initialize(name)
    if NAMES.include?(name)
      @name = name
    else
      raise "Unknown report name"
    end
  end

  def roots
    if name == 'Income Statement'
      RevenueOrExpense.roots
    elsif name == 'Balance Sheet'
      AssetOrLiability.roots
    end
  end
end
