require 'open-uri'
require 'xmlsimple'

# http://www.ecb.europa.eu/stats/exchange/eurofxref/html/index.en.html

namespace :fixer do
  namespace :download do
    desc 'Download current rates'
    task :current, :needs => [:environment] do
      EcbFeed.download_daily
    end
    
    namespace :history do
      desc 'Fetch 90-day history'
      task :ninety_days, :needs => [:environment] do
        EcbFeed.download_90_days
      end
      
      desc 'Fetch all history'
      task :all, :needs => [:environment] do
        EcbFeed.download_all
      end
    end
  end
end

module EcbFeed  
  BASE_URL = 'http://www.ecb.europa.eu/stats/eurofxref/'
  
  def self.download_daily
    self.download(BASE_URL + 'eurofxref-daily.xml')
  end
  
  def self.download_90_days
    self.download(BASE_URL + 'eurofxref-hist-90d.xml')
  end
  
  def self.download_all
    self.download(BASE_URL + 'eurofxref-hist.xml')
  end
  
  def self.download(url)
    feed = XmlSimple.xml_in(open(url).read)
    feed['Cube'][0]['Cube'].each do |snapshot|
      date = snapshot['time']
      snapshot['Cube'].each do |fx|
        ExchangeRate.find_or_create_by_currency_and_recorded_on(
          :currency     => fx['currency'],
          :recorded_on  => date,
          :rate         => fx['rate']
        )
      end
    end
  end
end