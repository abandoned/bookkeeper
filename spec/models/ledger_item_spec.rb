require File.dirname(__FILE__) + '/../spec_helper'

describe LedgerItem do
  before(:each) do
    @account = Factory(:account)
    @sender = Factory(:contact)
    @recipient = Factory(:contact)
    @ledger_item = Factory(:ledger_item,
                           :sender => @sender,
                           :recipient => @recipient,
                           :total_amount => 20.0,
                           :account => @account,
                           :transacted_on => Date.new(2009,1,31))
  end

  it "should belong to a account" do
    @ledger_item.account = nil
    lambda { @ledger_item.save! }.should raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not have a tax amount that exceeds the total amount when transaction is a debit" do
    @ledger_item.tax_amount = 21
    lambda { @ledger_item.save! }.should raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not have a tax amount that exceeds the total amount when transaction is a credit" do
    @ledger_item.total_amount = -20
    @ledger_item.tax_amount = -21
    lambda { @ledger_item.save! }.should raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not have a tax amount that is the inverse sign of the total amount" do
    @ledger_item.tax_amount = -1
    lambda { @ledger_item.save! }.should raise_error(ActiveRecord::RecordInvalid)
  end

  it "should default tax_amount to 0 if tax_amount is nil" do
    @ledger_item.tax_amount = nil
    @ledger_item.should be_valid
  end

  it "should have a valid currency code" do
    @ledger_item.currency = "ZZZ"
    lambda { @ledger_item.save! }.should raise_error(ActiveRecord::RecordInvalid)
  end

  it "should validate if transaction is between selves" do
    @sender.self = true
    @sender.save
    @recipient.self = true
    @recipient.save
    lambda { @ledger_item.save! }.should_not raise_error
  end

  it "should validate if transacting parties are not defined" do
    @ledger_item.sender = nil
    @ledger_item.recipient = nil
    lambda { @ledger_item.save! }.should_not raise_error
  end

  it "should not validate if debit and not from perspective of self" do
    @sender.self = true
    @sender.save
    lambda { @ledger_item.save! }.should raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not validate if credit and not from perspective of self" do
    @recipient.self = true
    @recipient.save
    @ledger_item.total_amount = -20.0
    lambda { @ledger_item.save! }.should raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not total 0" do
    @ledger_item.total_amount = 0
    lambda { @ledger_item.save! }.should raise_error(ActiveRecord::RecordInvalid)
  end

  context "scopes" do
    describe ".contact" do
      it "finds sender" do
        LedgerItem.contact(@sender).count.should eql 1
      end

      it "finds recipient" do
        LedgerItem.contact(@recipient).count.should eql 1
      end

      it "filters out anyone who is not sender or recipient" do
        LedgerItem.contact(Factory(:contact)).count.should eql 0
      end
    end

    describe ".from_date" do
      it "includes later dates" do
        LedgerItem.from_date('2009-01-30').count.should eql 1
      end

      it "includes date of query" do
        LedgerItem.from_date('2009-01-31').count.should eql 1
      end

      it "filters out earlier dates" do
        LedgerItem.from_date('2009-02-01').count.should eql 0
      end
    end

    describe ".to_date" do
      it "filters out later dates" do
        LedgerItem.to_date('2009-01-30').count.should eql 0
      end

      it "includes date of query" do
        LedgerItem.to_date('2009-01-31').count.should eql 1
      end

      it "includes earlier dates" do
        LedgerItem.to_date('2009-02-01').count.should eql 1
      end
    end

    describe ".perspective" do
      it "finds contact from whose perspective the transaction took place" do
        LedgerItem.perspective(@recipient).count.should eql 1
      end

      it "ignores contact from whose perspective the transaction did not take place" do
        LedgerItem.perspective(@sender).count.should eql 0
      end
    end
  end

  describe "query scoping" do
    before(:each) do
      Factory(:ledger_item,
              :transacted_on => Date.new(2009, 1, 1))
    end

    it "should scope transaction date on or after a date" do
      from = 'since Jan 15 2009'
      LedgerItem.scope_by(from).size.should == 1
    end

    it "should scope transaction date on or before a date" do
      to = 'until Jan 15 2009'
      LedgerItem.scope_by(to).size.should == 1
    end

    it "should not scope transaction date if date does not parse" do
      to = 'on Jan 15, 2009'
      LedgerItem.scope_by(to).size.should == 2
    end
  end
end
