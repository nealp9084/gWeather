require 'net/http'
require 'rexml/document'
require 'CGI'

require 'pry'

def assert &code
  if not code.call
    src = code.source_location
    raise "Assertion failed in #{src[0]} at line #{src[1]}."
  end
end

class GoogleParser
  @location
  @url
  @xml
  @doc

  def initialize location
    assert { location.length > 0 }
    @location = location

    @url = "http://www.google.com/ig/api?weather=#{CGI.escape location}"
    @xml = Net::HTTP.get_response(URI.parse @url).body
    @doc = REXML::Document.new @xml
  end

  def succeeded?
    return @doc.elements['count(//problem_cause)'].to_i == 0
  end

  def parse
    @doc.elements.each('xml_api_reply/weather') do |element|
      #TODO: handle each type of XML node: forecast info, current info, forecasts
    end
  end
end

class Forecast
  attr_accessor :day, :low, :high, :icon_url, :condition

  @xml_element
  @day
  @low
  @high
  @icon_url
  @condition

  def parse_item element
    return element.attribute('data').to_s.gsub('"', '')
  end

  def parse
    for item in @xml_element
      result = parse_item item
    
      case item.element.name
        when 'day_of_week'
          @day = result
        when 'low'
          @low = result.to_i
        when 'high'
          @high = result.to_i
        when 'icon'
          @icon_url = 'http://www.google.com/#{result}'
        when 'condition'
          @condition = result
      end
    end
  end

  def initialize xml_element
    @xml_element = xml_element
  end
end

gp = GoogleParser.new 'charlottesville'
assert { gp.succeeded? }
binding.pry

#TODO: FINISH CODING!

=begin
doc.elements.each('xml_api_reply/weather/forecast_conditions') do |element|
  for subelement in element
    day_of_week = 
    low = subelement.attribute('')
    binding.pry
  end 

  break
end
=end