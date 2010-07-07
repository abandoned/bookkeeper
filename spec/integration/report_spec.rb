require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Report do
  before(:each) do
    @company   = Factory(:contact, :self => true)
    @other     = Factory(:contact)
    @asset     = Factory(:asset_or_liability)
    @liability = Factory(:asset_or_liability)
    @revenue   = Factory(:revenue_or_expense)
    @expense   = Factory(:revenue_or_expense)
    @equity    = Factory(:asset_or_liability)
    [
      [
        Factory(:ledger_item, :total_amount =>  1000, :currency => "GBP", :transacted_on => "2008-12-01", :account => @asset,   :sender => @other, :recipient => @company),
        Factory(:ledger_item, :total_amount => -1000, :currency => "GBP", :transacted_on => "2008-12-01", :account => @revenue, :sender => @company, :recipient => @other)
      ], [
        Factory(:ledger_item, :total_amount =>  1500, :currency => "GBP", :transacted_on => "2009-01-01", :account => @asset,   :sender => @other, :recipient => @company),
        Factory(:ledger_item, :total_amount => -1500, :currency => "GBP", :transacted_on => "2009-01-01", :account => @revenue, :sender => @company, :recipient => @other)
      ], [
        Factory(:ledger_item, :total_amount =>  1000, :currency => "USD", :transacted_on => "2009-02-01", :account => @asset,   :sender => @other, :recipient => @company),
        Factory(:ledger_item, :total_amount => -1000, :currency => "USD", :transacted_on => "2009-02-01", :account => @revenue, :sender => @company, :recipient => @other)
      ]
    ].each { |matches| Factory(:match, :ledger_items => matches) }

    Factory(:exchange_rate, :currency => "GBP", :rate => 0.8, :recorded_on => "2008-12-31")
    Factory(:exchange_rate, :currency => "USD", :rate => 1, :recorded_on => "2008-12-31")
    Factory(:exchange_rate, :currency => "GBP", :rate => 0.5, :recorded_on => "2009-12-31")
    Factory(:exchange_rate, :currency => "USD", :rate => 1, :recorded_on => "2009-12-31")

    @params = {
     :base_currency => "USD",
     :perspective   => @company.id
    }
  end

  context "of the 2008 balance sheet" do
    before(:each) do
      @params.merge!({
        :id                 => 'balance-sheet',
        :to_date            => "2008-12-31",
        :base_currency_date => "2008-12-31" })
      @report = Report.new(@params)
    end

    it "has a balance of US$1,250" do
      @report.net.round(2).to_f.should eql(1250.0)
    end
  end

  context "of the 2009 balance sheet" do
    before(:each) do
      @params.merge!({
        :id                 => 'balance-sheet',
        :to_date            => "2009-12-31",
        :base_currency_date => "2009-12-31" })
      @report = Report.new(@params)
    end

    it "has a balance of US$6,000 " do
      @report.net.round(2).to_f.should eql(6000.0)
    end
  end

  context "of the 2008 income statement" do
    before(:each) do
      @params.merge!({
        :id                 => 'income-statement',
        :from_date          => "2008-01-01",
        :to_date            => "2008-12-31",
        :base_currency_date => "2008-12-31" })
      @report = Report.new(@params)
    end

    it "has a balance of US$1,250" do
      @report.net.round(2).to_f.should eql(-1250.0)
    end
  end

  context "of the 2009 income statement" do
    before(:each) do
      @params.merge!({
        :id                 => 'income-statement',
        :from_date          => "2009-01-01",
        :to_date            => "2009-12-31",
        :base_currency_date => "2009-12-31" })
      @report = Report.new(@params)
    end

    it "has a balance of US$4,000" do
      @report.net.round(2).to_f.should eql(-4000.0)
      p @report.delta_in_assets_of_previous_year
    end
  end
end
