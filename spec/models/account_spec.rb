require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Account do
  before(:each) do
    @parent = Factory(:account)
    @child = Factory(:account, :parent => @parent)
  end
  
  it "should not descend from itself" do
    @parent.parent = @parent
    lambda {@parent.save!}.should raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "should not descend from its descendants" do
    @parent.parent = @child
    lambda {@parent.save!}.should raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "should not come into being if parent is not found" do
    lambda {Factory(:account, :parent_id => 0)}.should raise_error(ActiveRecord::RecordNotFound)
  end
  
  it "should not orphan children" do
    lambda {@parent.destroy}.should raise_error(Ancestry::AncestryException)
  end
  
  it "should not orphan ledger items" do
    ledger_item = Factory(:ledger_item,
                          :account => @child)
    lambda {@child.destroy}.should raise_error(ActiveRecord::RecordNotDestroyed)
  end
  
  it "should not have a blank name" do
    @parent.name = ""
    lambda {@parent.save!}.should raise_error(ActiveRecord::RecordInvalid)
  end
  
  describe "when destroyed" do
    it "should destroy associated rules" do
      2.times { Factory(:rule_with_matched_description, :new_account => @child) }
      2.times { Factory(:rule_with_matched_contact, :new_account => @child) }
      @child.destroy
      Rule.count.should eql(0)
    end
  end

  describe "totals" do
    before(:each) do
      @self = Factory(:contact, :self => true)
      @other = Factory(:contact)
      matches = [
        Factory(:ledger_item, :account => @parent, :sender => @self, :recipient => @other, :total_amount => -100),
        Factory(:ledger_item, :sender => @other, :recipient => @self, :total_amount => 100)
      ]
      match = Factory(:match, :ledger_items => matches)
      Factory(:exchange_rate, :currency => 'USD', :rate => 1.5, :recorded_on => 5.years.ago)
      Factory(:exchange_rate, :currency => 'GBP', :rate => 0.75, :recorded_on => 5.years.ago)
    end

    it "should return total" do
      @parent.total_for?(@self.id).should be_true
      @parent.total_for(@self.id)["USD"].to_f.should == -100.0
    end

    it "should return total in a base currency" do
      @parent.total_for_in_base_currency(@self.id, nil, nil, 'GBP').should == -50.0
    end

    it "should scope by perspective" do
      @other.update_attribute(:self, true)
      @parent.total_for(@other.id).should be_blank
      @parent.total_for_in_base_currency(@other.id, nil, nil, 'GBP').should == 0.0
    end

    it "should not include unmatched ledger items" do
      Factory(:ledger_item, :account => @parent, :sender => @self, :recipient => @other, :total_amount => -200)
      @parent.total_for(@self.id)["USD"].to_f.should == -100.0
    end

    describe "grand" do
      before(:each) do
        matches = [
          Factory(:ledger_item, :account => @child, :sender => @self, :recipient => @other, :total_amount => -200),
          Factory(:ledger_item, :sender => @other, :recipient => @self, :total_amount => 200)
        ]
        Factory(:match, :ledger_items => matches)
      end

      it "should return grand total" do
        @parent.grand_total_for?(@self.id).should be_true
        @parent.grand_total_for(@self.id)["USD"].to_f.should == -300.0
      end

      it "should return total in a base currency" do
        @parent.grand_total_for_in_base_currency(@self.id, nil, nil, 'GBP').should == -150.0
      end

      it "should scope by perspective" do
        @other.update_attribute(:self, true)
        @parent.grand_total_for(@other.id).should be_blank
        @parent.grand_total_for_in_base_currency(@other.id, nil, nil, 'GBP').should == 0.0
      end

      it "should not include unmatched ledger items" do
        Factory(:ledger_item, :account => @child, :sender => @self, :recipient => @other, :total_amount => -200)
        @parent.grand_total_for(@self.id)["USD"].to_f.should == -300.0
      end
    end
  end
end

