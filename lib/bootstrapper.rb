class Bootstrapper
  def self.record(name, object)
    instance_variable_set("@#{name.tr(' ', '_').downcase}".to_sym, object)
  end
  
  def self.bootstrap!
    @self, @starbucks, @customer = Person.create!([
      { :name => "Self",
        :country => "United States",
        :is_self => true },
      { :name => "Starbucks",
        :country => "United States",
        :is_self => false },
      { :name => "Customer",
        :country => "United States",
        :is_self => false },
    ])
    {
      "Bank Accounts" => ["Demo Bank Account"],
      "Expenses" => ["Coffee"]
    }.each_pair do |parent_name, children|
      parent = Account.find_by_name(parent_name)
      record(parent_name, parent)
      children.each do |name|
        account = Account.create(
          :name => name,
          :parent => parent
        )
        record(name, account)
      end
    end
    Mapping.create!([
      { :name => "Citibank",
        :currency => "USD",
        :date_row => 1,
        :total_amount_row => 3,
        :description_row => 2, 
        :has_title_row => false,
        :day_follows_month => true,
        :reverses_sign => false },
      { :name => "Amex, US",
        :currency => "USD",
        :date_row => 1,
        :total_amount_row => 3,
        :description_row => 4,
        :identifier_row => 2, 
        :has_title_row => false,
        :day_follows_month => true,
        :reverses_sign => true },
      { :name => "Amex, UK",
        :currency => "GBP",
        :date_row => 1,
        :total_amount_row => 3,
        :description_row => 4,
        :identifier_row => 2, 
        :has_title_row => false,
        :day_follows_month => false,
        :reverses_sign => true }
    ])
    
    @i1, @i2, @i3, @i4 = LedgerItem.create!([
      { :sender => @self,
        :recipient => @starbucks,
        :total_amount => -2.99,
        :currency => "USD",
        :account => @demo_bank_account,
        :transacted_on => 1.days.ago
      },
      { :sender => @self,
        :recipient => @starbucks,
        :total_amount => -3.99,
        :currency => "USD",
        :account => @demo_bank_account,
        :transacted_on => Date.today
      },
      { :sender => @starbucks,
        :recipient => @self,
        :total_amount => 2.99,
        :currency => "USD",
        :account => @coffee,
        :transacted_on => 1.days.ago
      },
      { :sender => @starbucks,
        :recipient => @self,
        :total_amount => 3.99,
        :currency => "USD",
        :account => @coffee,
        :transacted_on => Date.today
      },
      { :sender => @customer,
        :recipient => @self,
        :total_amount => 100,
        :currency => "USD",
        :account => @demo_bank_account,
        :transacted_on => 10.days.ago
      },
      { :sender => @customer,
        :recipient => @self,
        :total_amount => 75,
        :currency => "USD",
        :account => Account.find_by_name("Accounts Receivable"),
        :transacted_on => Date.today
      },
    ])
    Match.create!([
      {
        :ledger_items => [@i1, @i3]
      }
    ])
  end
end
