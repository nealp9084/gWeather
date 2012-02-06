require 'rexml/document'

class CurrentWeather
  attr_reader :condition, :temp, :humidity, :icon_url, :wind
  def initialize xml_element
    @xml_element = xml_element
    parse
  end

  def parse
    for item in @xml_element
      data = item.attributes['data'].to_s

      case item.name
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
end