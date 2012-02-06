require 'rexml/document'

module WeatherData
  def get_data item
    return item.attributes['data'].to_s
  end

  def parse
    for item in @xml_element
      handle_item(item.name, get_data(item))
    end
  end
end

class Forecast
  include WeatherData
  attr_reader :day, :low, :high, :icon_url, :condition
  def initialize xml_element
    @xml_element = xml_element
    parse
  end

  def handle_item name, data
    days = { 'Sun' => 'Sunday',
      'Mon' => 'Monday', 'Tue' => 'Tuesday',
      'Wed' => 'Wednesday', 'Thu' => 'Thursday',
      'Fri' => 'Friday', 'Sat' => 'Saturday' }

    case name
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

class CurrentWeather
  include WeatherData
  attr_reader :condition, :temp, :humidity, :icon_url, :wind
  def initialize xml_element
    @xml_element = xml_element
    parse
  end

  def handle_item name, data
    case name
    when 'condition'
      @condition = data
    when 'temp_f'
      @temp = data.to_i
    when 'humidity'
      humidity = data.to_i
    when 'icon'
      @icon_url = "http://www.google.com/#{data}"
    when 'wind_condition'
      @wind = data
    end
  end
end