require 'spec_helper'

describe Import do
  before(:each) do
    @account = Factory(:account)
  end
  
  describe "Amex, UK" do
    before(:each) do
      file_path = "../fixtures/amex-uk-sample.csv"
      
      @mapping = Factory(:mapping,
        :name => 'Amex, UK',
        :currency => 'GBP',
        :date_row => 1,
        :total_amount_row => 3,
        :description_row => 4,
        :second_description_row => nil,
        :has_title_row => false,
        :day_follows_month => false,
        :reverses_sign => true)
        
      @uploader = mock_uploader(file_path) 
      @uploader.stub!(:path).and_return(Rails.root.to_s + '/spec/fixtures/' + file_path)
      
      @import = Factory(:import,
        :account => @account,
        :mapping => @mapping,
        :file    => @uploader)
    end
    
    it "should import with correct ending balance" do
      @import.ending_balance = 6587.42
      @import.copy_temp_file
      @import.perform
      @import.should be_processed
      LedgerItem.all.size.should == @import.message.match(/\d+/).to_s.to_i
    end
    
    it "should fail to import with incorrect ending balance" do
      @import.copy_temp_file
      @import.perform
      @import.should be_failed
    end
  end
  
  describe "Amex, US; with no identifier row and with thousand separators in numbers" do
    before(:each) do
      file_path = "../fixtures/amex-us-sample.csv"
      @mapping = Factory(:mapping,
        :name => 'Amex, US',
        :currency => 'USD',
        :date_row => 1,
        :total_amount_row => 5,
        :description_row => 2,
        :second_description_row => 4,
        :has_title_row => true,
        :day_follows_month => true,
        :reverses_sign => true)
      
      @uploader = mock_uploader(file_path) 
      @uploader.stub!(:path).and_return(Rails.root.to_s + '/spec/fixtures/' + file_path)
    
      @import = Factory(:import,
        :account => @account,
        :mapping => @mapping,
        :file    => @uploader)
    end
    
    it "should import with correct ending balance" do
      @import.ending_balance = 7886.55
      @import.copy_temp_file
      @import.perform
      @import.should be_processed
      LedgerItem.all.size.should == @import.message.match(/\d+/).to_s.to_i
    end
    
    it "should fail to import with incorrect ending balance" do
      @import.copy_temp_file
      @import.perform
      @import.should be_failed
    end
  end
  
  describe "Citi, with existing opening balance" do
    before(:each) do
     file_path = "../fixtures/citi-sample.csv"
     Factory(:ledger_item,
        :account => @account,
        :total_amount => 1047.98)
      
      @mapping = Factory(:mapping,
        :name => 'Citi',
        :currency => 'USD',
        :date_row => 1,
        :total_amount_row => 3,
        :description_row => 2,
        :second_description_row => nil,
        :has_title_row => false,
        :day_follows_month => true,
        :reverses_sign => false)
      
      @uploader = mock_uploader(file_path) 
      @uploader.stub!(:path).and_return(Rails.root.to_s + '/spec/fixtures/' + file_path)
    
      @import = Factory(:import,
        :account => @account,
        :mapping => @mapping,
        :file    => @uploader)
    end
    
    it "should import with correct ending balance" do
      @import.ending_balance = 20475.49
      @import.copy_temp_file
      @import.perform
      @import.should be_processed
      LedgerItem.all.size.should == @import.message.match(/\d+/).to_s.to_i  + 1
    end
    
    it "should fail to import with incorrect ending balance" do
      @import.copy_temp_file
      @import.perform
      @import.should be_failed
    end
  end
end

def mock_uploader(file, type = 'text/plain')
  filename = "%s/%s" % [ File.dirname(__FILE__), file ]
  uploader = ActionController::UploadedStringIO.new
  uploader.original_path = filename
  uploader.content_type = type
  def uploader.read
    File.read(original_path)
  end
  def uploader.size
    File.stat(original_path).size
  end
  uploader
end