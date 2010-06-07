module ReportsHelper
  def switch_sign_if_income_statement
    @report.name == "Income Statement" ? -1 : 1
  end
end
