require './GoogleParser'

gp = GoogleParser.new ARGV.first

current = gp.current

puts "It's #{current.condition} in #{gp.city}."

puts "The temperature is #{current.temp} degrees with a humidity of #{current.humidity}."
puts "The wind is #{current.wind_direction} at #{current.wind_speed} mph, and the weather can be modeled with #{current.icon_url} ."

for forecast in gp.forecasts
  puts
  puts "Forecast for #{forecast.day}"
  puts "The temperature will be #{forecast.low} to #{forecast.high} degrees."
  puts "The weather is #{forecast.condition}, and the weather can be modeled with #{forecast.icon_url} ."
end
