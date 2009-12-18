class CreateExchangeRates < ActiveRecord::Migration
  def self.up
    create_table  :exchange_rates do |t|
      t.string    :currency
      t.decimal   :rate, :precision => 20, :scale => 4
      t.date      :recorded_on
    end
    
    add_index     :exchange_rates, :currency
    add_index     :exchange_rates, :recorded_on
  end

  def self.down
    drop_table    :exchange_rates
  end
end
