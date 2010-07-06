require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Rule do
  before(:each) do
    @account = Factory(:account)
    @new_account = Factory(:account)
    @sender = Factory(:contact)
    @recipient = Factory(:contact, :self => true)
    @ledger_item = Factory(:ledger_item,
      :total_amount => 20,
      :description => "Foo bar baz",
      :account => @account
    )
  end
  
  it "should match by description" do
    @rule = Factory(:rule,
      :account              => @account,
      :matched_description  => "[a-c]ar",
      :matched_debit        => true,
      :new_sender           => @sender,
      :new_recipient        => @recipient,
      :new_account          => @new_account
    )
    
    @ledger_item = LedgerItem.find(@ledger_item.id)
    
    @ledger_item.sender.should == @sender
    @ledger_item.recipient.should == @recipient
    @ledger_item.matched?.should be_true
    
    @last_ledger_item = LedgerItem.last
    @last_ledger_item.sender.should == @recipient
    @last_ledger_item.recipient.should == @sender
    @last_ledger_item.account.should == @new_account
    @last_ledger_item.total_amount.should == @ledger_item.total_amount * -1.0
  end
  
  it "should not update a ledger item when debit rule matches but description does not" do
    @rule = Factory(:rule,
      :account              => @account,
      :matched_description  => "[cde]ar",
      :matched_debit        => true,
      :new_sender           => @sender,
      :new_recipient        => @recipient,
      :new_account          => @new_account
    )
    @ledger_item = LedgerItem.find(@ledger_item.id)
    @ledger_item.sender.should be_nil
  end
  
  it "should not update a ledger item when description matches but debit rule does not" do
    @rule = Factory(:rule,
      :account              => @account,
      :matched_description  => "[a-c]ar",
      :matched_debit        => false,
      :new_sender           => @sender,
      :new_recipient        => @recipient,
      :new_account          => @new_account
    )
    @ledger_item = LedgerItem.find(@ledger_item.id)
    @ledger_item.sender.should be_nil
  end
  
  it "should match by contacts" do
    @ledger_item.update_attributes!(
      :sender => @sender,
      :recipient => @recipient
    )
    @rule = Factory(:rule,
      :account              => @account,
      :matched_description  => "[a-c]ar",
      :matched_debit        => true,
      :matched_sender       => @sender,
      :matched_recipient    => @recipient,
      :new_account          => @new_account
    )
    
    @ledger_item = LedgerItem.find(@ledger_item.id)
    
    @ledger_item.matched?.should be_true
    
    @last_ledger_item = LedgerItem.last
    @last_ledger_item.sender.should == @recipient
    @last_ledger_item.recipient.should == @sender
    @last_ledger_item.account.should == @new_account
    @last_ledger_item.total_amount.should == @ledger_item.total_amount * -1.0
  end
  
  it "should have at least one matcher" do
    lambda { @rule = Factory(:rule,
      :account              => @account,
      :matched_debit        => true,
      :new_sender           => @recipient,
      :new_recipient        => @sender,
      :new_account          => @new_account
    )}.should raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "should not validate if it both matches and assigns contact" do
    lambda { @rule = Factory(:rule,
      :account              => @account,
      :matched_description  => "[a-c]ar",
      :matched_debit        => true,
      :matched_sender       => @sender,
      :matched_recipient    => @recipient,
      :new_recipient        => @sender,
      :new_account          => @new_account
    )}.should raise_error(ActiveRecord::RecordInvalid)
  end
end
