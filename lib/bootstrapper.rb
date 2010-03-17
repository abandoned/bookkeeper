class Bootstrapper
  def self.record(name, object)
    instance_variable_set("@#{name.tr(' ', '_').downcase}".to_sym, object)
  end
  
  def self.bootstrap!
    [
      { :name         => 'Awesome Bakery',
        :contact_name => 'Joe Baker',
        :address      => '10 Main Street',
        :city         => 'New York',
        :postal_code  => '10001',
        :state        => 'NY',
        :country      => 'United States',
        :country_code => 'US',
        :tax_number   => '0123456-10',
        :self         => true },
      { :name         => 'Flour Corp',
        :country      => 'United States',
        :self         => false },
      { :name         => 'John Doe',
        :country      => 'United States',
        :self         => false },
    ].each do |attributes|
      contact = Contact.create!(attributes)
      record(attributes[:name], contact)
    end
    
    {
      'Bank Accounts' => ['Checking Account'],
      'Supplies'      => ['Flour']
    }.each_pair do |name, children|
      parent = Account.find_by_name(name)
      record(name, parent)
      children.each do |name|
        account = Account.create!(
          :name   => name,
          :parent => parent
        )
        record(name, account)
      end
    end
    
    counter = 0
    Mapping.create!([
      { :name               => 'Citibank',
        :currency           => 'USD',
        :date_row           => 1,
        :total_amount_row   => 3,
        :description_row    => 2, 
        :has_title_row      => false,
        :day_follows_month  => true,
        :reverses_sign      => false },
    ])
    
    [
      { :sender         => @awesome_bakery,
        :recipient      => @flour_corp,
        :total_amount   => -250,
        :currency       => 'USD',
        :account        => @checking_account,
        :description    => 'Flour purchased',
        :transacted_on  => 14.days.ago
      },
      { :sender         => @awesome_bakery,
        :recipient      => @flour_corp,
        :total_amount   => -500,
        :currency       => 'USD',
        :account        => @checking_account,
        :description    => 'Flour purchased',
        :transacted_on  => 7.days.ago
      },
      { :sender         => @flour_corp,
        :recipient      => @awesome_bakery,
        :total_amount   => 250,
        :currency       => 'USD',
        :account        => @flour,
        :transacted_on  => 14.days.ago
      },
      { :sender         => @flour_corp,
        :recipient      => @awesome_bakery,
        :total_amount   => 500,
        :currency       => 'USD',
        :account        => @flour,
        :transacted_on  => 7.days.ago
      },
      { :sender         => @john_doe,
        :recipient      => @awesome_bakery,
        :total_amount   => 25,
        :currency       => 'USD',
        :account        => @checking_account,
        :description    => 'Bread sold',
        :transacted_on  => 5.days.ago
      },
      { :sender         => @john_doe,
        :recipient      => @awesome_bakery,
        :total_amount   => 40,
        :currency       => 'USD',
        :account        => Account.find_by_name('Accounts Receivable'),
        :description    => 'Bread sold',
        :transacted_on  => Date.today
      },
    ].each do |attributes|
      ledger_item = LedgerItem.create!(attributes)
      counter += 1
      record("transaction_#{counter}", ledger_item)
    end
    
    Match.create!([
      {
        :ledger_items => [@transaction_1, @transaction_3]
      }
    ])
  end
end