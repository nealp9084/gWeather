require './GoogleParser.rb'

gp = GoogleParser.new gets.chomp
gp.parse
puts "It's #{gp.current.condition} in #{gp.city}!"
