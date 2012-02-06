require 'net/http'
require 'CGI'
require 'rexml/document'
require './common.rb'
require './CurrentWeather.rb'
require './Forecast.rb'

class GoogleParser
  attr_accessor :city, :current, :forecasts
  def initialize location
    assert { location.length > 0 }
    @location = location

    @url = "http://www.google.com/ig/api?weather=#{CGI.escape location}"
    @xml = Net::HTTP.get_response(URI.parse @url).body
    @doc = REXML::Document.new @xml

    @forecasts = Array.new

    assert { parse }
  end

  def succeeded?
    return @doc.elements['count(//problem_cause)'].to_i == 0
  end

  def handle_information element
    @city = element.elements['city'].attributes['data'].to_s
  end

  def handle_current element
    @current = CurrentWeather.new(element)
  end

  def handle_forecast element
    @forecasts << Forecast.new(element)
  end

  def parse
    return false unless succeeded?

    for element in @doc.elements['xml_api_reply/weather']
      case element.name
      when 'forecast_information'
        handle_information element
      when 'current_conditions'
        handle_current element
      when 'forecast_conditions'
        handle_forecast element
      end
    end

    return true
  end
end
