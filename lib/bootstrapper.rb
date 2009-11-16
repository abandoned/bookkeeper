class Bootstrapper
  def self.bootstrap!
    Person.create!([
      { :name => "Paper Cavalier, Llc",
        :country => "United States",
        :is_self => true },
      { :name => "Paper Cavalier, Ltd",
        :country => "United Kingdom",
        :is_self => true },
      { :name => "Starbucks",
        :country => "United States",
        :is_self => false },
      { :name => "Costa Coffee",
        :country => "United Kingdom",
        :is_self => false }
    ])
    {"Bank Accounts" => ["Citibank", "Barclays"]}.
      each_pair do |parent_name, children|
      parent = Account.find_by_name(parent_name)
      children.each{ |name| Account.create(
        :name => name,
        :parent => parent) }
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
  end
end
