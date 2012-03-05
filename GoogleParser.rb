require 'cgi'
require 'net/http'
require 'rexml/document'
require './WeatherData.rb'

class GoogleParser
  attr_reader :city, :url, :current, :forecasts

  def initialize location
    raise ArgumentError, 'No location specified' if location.nil? or location.empty?

    @location = location
    @url = "http://www.google.com/ig/api?weather=#{CGI.escape location}"
    response = Net::HTTP.get_response(URI.parse @url)

    if response.code.to_i != 200
      raise HTTPError, 'Unable to receive weather data.'
    end

    xml = response.body
    @doc = REXML::Document.new xml
    @forecasts = []

    if succeeded?
      parse
    else
      raise ArgumentError, 'Your location was not recognized.'
    end
  end

  protected

  def succeeded?
    return @doc.elements['count(//problem_cause)'] == 0
  end

  def handle_information element
    @city = element.elements['city'].attributes['data'].to_s
    tokens = @city.split(/[ ,]/).reject { |x| x.empty? }

    if tokens.size >= 2
      tokens[0...-1].map! { |x| x.capitalize }
      tokens.last.upcase!
      @city = "%s, %s" % [tokens[0...-1].join(' '), tokens.last]
    elsif tokens.size == 1
      @city.capitalize!
    end
  end

  def handle_current element
    @current = CurrentWeather.new element
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
