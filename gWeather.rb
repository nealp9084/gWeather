require './GoogleParser.rb'

gp = GoogleParser.new(gets.chomp)
puts "It's #{gp.current.condition} in #{gp.city}!"