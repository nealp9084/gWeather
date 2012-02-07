require 'net/http'
require 'cgi'
require 'rexml/document'
require './common.rb'
require './WeatherData.rb'

class GoogleParser
  attr_reader :city, :current, :forecasts
  def initialize location
    raise ArgumentError, 'No location specified' if location.empty?

    @location = location
    @url = "http://www.google.com/ig/api?weather=#{CGI.escape location}"
    @xml = Net::HTTP.get_response(URI.parse @url).body
    @doc = REXML::Document.new @xml
    @forecasts = Array.new

    raise ArgumentError, 'Your location was not recognized.' unless succeeded?
    parse
  end

  protected

  def succeeded?
    return @doc.elements['count(//problem_cause)'].to_i == 0
  end

  def handle_information element
    @city = element.elements['city'].attributes['data'].to_s.capitalize
  end

  def handle_current element
    @current = CurrentWeather.new(element)
  end

  def handle_forecast element
    @forecasts << Forecast.new(element)
  end

  def parse
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
  end
end
