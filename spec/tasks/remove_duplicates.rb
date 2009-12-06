require File.dirname(__FILE__) + '/../spec_helper'
require "rake"

describe 'bugs:remove_duplicates rake task' do
  before(:each) do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require "lib/tasks/remove_duplicates"
    Rake::Task.define_task(:environment)
    
    @match      = Factory(:match)
    @sender     = Factory(:contact)
    @recipient  = Factory(:contact)
    
    Factory(:ledger_item,
      :sender       => @sender,
      :recipient    => @recipient,
      :total_amount => 1,
      :match        => @match
    )
    Factory(:ledger_item,
      :sender       => @recipient,
      :recipient    => @sender,
      :total_amount => -1,
      :match        => @match
    )
    
    # This is the buggy entry
    @buggy_entry = Factory(:ledger_item,
      :sender       => Factory(:contact),
      :recipient    => Factory(:contact),
      :match        => Factory(:match)
    )
  end
  
  after(:each) do
    Rake.application = nil
  end
  
  it "should remove duplicate" do
    @rake['bugs:remove_duplicates'].invoke
    Match.all.size.should == 1
    LedgerItem.all.size.should == 2
    LedgerItem.last.should_not == @buggy_entry
  end
end