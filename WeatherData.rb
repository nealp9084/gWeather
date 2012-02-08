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

class CurrentWeather
  include WeatherData
  attr_reader :condition, :temp, :humidity, :icon_url, :wind_direction, :wind_speed
  def initialize xml_element
    @xml_element = xml_element
    parse
  end

  protected

  def format_humidity data
    if data =~ /Humidity: (\d+)%$/
    return $1.to_i
    else
    return 0
    end
  end

  def handle_wind wind
    if wind =~ /Wind: (\w{1,2}) at (\d+) mph$/
      directions =
      {
        'N' => 'North', 'E' => 'East',
        'S' => 'South', 'W' => 'West',
        'NE' => 'Northeast', 'NW' => 'Northwest',
        'SE' => 'Southeast', 'SW' => 'Southwest'
      }

      @wind_direction = directions[$1]
      @wind_speed = $2.to_i
    else
      @wind_direction = 'Unknown'
      @wind_speed = 0
    end
  end

  def handle_item name, data
    case name
    when 'condition'
      @condition = data
    when 'temp_f'
      @temp = data.to_i
    when 'humidity'
      @humidity = format_humidity data
    when 'icon'
      @icon_url = "http://www.google.com/#{data}"
    when 'wind_condition'
      handle_wind data
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

  protected

  def format_day day
    case day
    when 'Sun'
      return 'Sunday'
    when 'Mon'
      return 'Monday'
    when 'Tue'
      return 'Tuesday'
    when 'Wed'
      return 'Wednesday'
    when 'Thu'
      return 'Thursday'
    when 'Fri'
      return 'Friday'
    when 'Sat'
      return 'Saturday'
    else
      return day
    end
  end

  def handle_item name, data
    case name
    when 'day_of_week'
      @day = format_day data
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
