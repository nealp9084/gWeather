require 'rexml/document'

class Forecast
  attr_accessor :day, :low, :high, :icon_url, :condition
  def initialize xml_element
    @xml_element = xml_element
    parse
  end

  def parse
    days = { 'Sun' => 'Sunday',
      'Mon' => 'Monday', 'Tue' => 'Tuesday',
      'Wed' => 'Wednesday', 'Thu' => 'Thursday',
      'Fri' => 'Friday', 'Sat' => 'Saturday' }

    for item in @xml_element
      data = item.attributes['data'].to_s

      case item.name
      when 'day_of_week'
        @day = days[data]
      when 'low'
        @low = data.to_i
      when 'high'
        @high = data.to_i
      when 'icon'
        @icon_url = "http://www.google.com/#{data}"
      when 'condition'
        @condition = data
      end
    end
  end
end