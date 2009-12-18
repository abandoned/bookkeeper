class ExchangeRate < ActiveRecord::Base
  def self.currencies
    @currencies ||= self.all(:select => 'distinct currency').map(&:currency) << 'EUR'
  end
  
  def self.current(base, quote)
    self.historical(base, quote, Date.today)
  end
  
  def self.historical(base, quote, date)
    if base == quote
      1.0
    elsif base == 'EUR'
      fx = self.first(
        :conditions => ['currency = ? and recorded_on <= ?', quote, date],
        :order      => 'recorded_on desc',
        :limit      => 1
      )
      fx.rate.to_f
    elsif quote == 'EUR'
      fx = self.first(
        :conditions => ['currency = ? and recorded_on <= ?', base, date],
        :order      => 'recorded_on desc',
        :limit      => 1
      )
      1.0 / fx.rate.to_f
    else
      fx = self.all(
        :conditions => ['currency in (?, ?) and recorded_on <= ?', base, quote, date],
        :order      => 'recorded_on desc',
        :limit      => 2
      )
      if fx.first.currency == quote
        (fx.first.rate / fx.last.rate).to_f
      else
        (fx.last.rate / fx.first.rate).to_f
      end
    end
  end
end