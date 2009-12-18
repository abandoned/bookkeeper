class FixerGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.migration_template 'migration.rb', 'db/migrate',
                           :migration_file_name => 'create_exchange_rates'
      m.file('exchange_rate.rb', 'app/models/exchange_rate.rb')
    end
  end
end