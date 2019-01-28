require_relative 'player'
require_relative 'game'

player_list = []
num_players = 0

until num_players > 0
  system("clear")
  puts "How many players? Please enter a number: "
  num_players = gets.chomp.to_i
end

player_count = 0
until player_count == num_players
  puts "Enter player's name: "
  name = gets.chomp.to_s
  person = Player.new(name)
  player_list << person
  player_count += 1
end

Game.new(player_list)


