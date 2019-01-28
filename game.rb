require "set"

class Game
  attr_accessor :players

  def initialize(start_players)
    @players = start_players  # an array of class instances
    @guess_fragment = ""
    @valid_fragment = ""
    @tries_per_turn = 3
    @dictionary = Set.new
    
    File.open('dictionary.txt', "r") do |file|
      file.each_line do |line|
        @dictionary << line.chomp
      end
    end
    system("clear")
    play_round
  end

  def new_round
    @guess_fragment = ""
    @valid_fragment = ""
    @tries_per_turn = 3
    @players.rotate!
    prompt_start_round
    play_round
  end

  def play_round
    @players.each { |player| take_turn(player) }
    check_standings
    play_round
  end

  def take_turn(player)
    prompt_take_turn(player, @tries_per_turn)
    letter = player.get_letter(player.name)
    @guess_fragment = @valid_fragment + letter.to_s
    if check_fragment(@guess_fragment) == false && @tries_per_turn > 1
      prompt_invalid_guess(@guess_fragment)
      @tries_per_turn -= 1
      take_turn(player)
    elsif check_fragment(@guess_fragment) == false && @tries_per_turn == 1
      prompt_invalid_guess(@guess_fragment)
      too_many_tries_lose_round(player)
    else
      @valid_fragment = @guess_fragment
      if complete_word?
        completed_word_lose_round(player)
      else
        prompt_valid_guess
      end
      true
    end
  end

  def check_fragment(fragment)
    @dictionary.each do |word|
      frag = word[0...fragment.length]
      if fragment == frag
        return true
      end
    end
    false
  end

  def complete_word?
    @dictionary.each do |word|
      if @valid_fragment == word
        return true
      end
    end
    false
  end

  def check_standings
    @players.each do |player|
      if player.score == "GHOST" && @players.length > 2
        prompt_player_out
        @players.delete(player)
      elsif player.score == "GHOST" && @players.length == 2
        prompt_player_out
        @players.delete(player)
        prompt_game_over
      end
    end
  end

  def too_many_tries_lose_round(player)
    prompt_too_many_tries
    player.add_to_score
    check_standings
    prompt_print_scores
    sleep(2)
    new_round
  end

  def completed_word_lose_round(player)
    prompt_complete_word_lose_round
    player.add_to_score
    prompt_print_scores
    sleep(2)
    check_standings
    new_round
  end

# ----------------------------
  # Command line UI Prompts
# ----------------------------

  def prompt_start_round
    system("clear")
    puts "Starting a new round."
  end

  def prompt_take_turn(player, tries)
    puts "You get #{tries} tries."
    puts "Current fragment is: #{@valid_fragment}"
    print "#{player.name}, make a guess: "
  end

  def prompt_invalid_guess(guess_frag)
    puts
    puts "There are no words in the dictionary"
    puts "starting with '#{guess_frag}'."
    sleep(2)
    system("clear")
  end

  def prompt_too_many_tries
    puts
    puts "You had three chances to enter a valid letter."
    puts "You lose this round."
    sleep(2)
    puts
  end

  def prompt_complete_word_lose_round
    puts
    puts "Good guess, but #{@valid_fragment} is a complete word."
    puts "You lose this round."
    sleep(2)
  end

  def prompt_valid_guess
    puts
    puts "That was a good guess!"
    puts "New fragment is: #{@valid_fragment}"
    sleep(2)
    system("clear")
  end

  def prompt_print_scores
    system("clear")
    puts "--------------------"
    puts "       Scores       "
    puts "--------------------"
    @players.each do |player|
      dots = 20 - (player.score.length + player.name.length)
      print player.name
      print "." * dots
      print player.score
      puts
    end
  end

  def prompt_player_out
    system("clear")
    puts "#{player.name} is out of the game!"
    sleep(2)
  end

  def prompt_game_over
    system("clear")
    puts "And the winner is...#{@players[0].name}!"
    puts
    puts
    puts
    puts "Want to play again? Enter Y or N."
    if gets.chomp.upcase == "Y"
      load "play_ghost.rb"
    else
      exit
    end
  end

end #end class Game