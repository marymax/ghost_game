class Player
  attr_reader :name
  attr_accessor :score, :letter

  GHOST = "GHOST"
  ALPHABET = "abcdefghijklmnopqrstuvwxyz"

  def initialize (name)
    #(name)
    @name = name.capitalize
    @losses = 0
    @score = ""
    @letter = ""
  end

  def get_letter(player)
    # puts "#{player.capitalize}, guess a letter"
    @letter = gets.chomp.downcase
    until validate_guess(@letter)
      get_letter(player)
    end
    letter
  end

  def validate_guess(letter)
    case
    when letter.length > 1
      puts "Please input a single letter: "
      false
    when letter.length == 0
      puts "Enter a letter, not a return: "
      false
    when ALPHABET.include?(letter)
      true
    else
      print "That wasn't a letter! Try again: "
      false
    end
  end

  def add_to_score
    @losses += 1
    @score = GHOST[0...@losses]
  end

end # end of class Player