require "yaml"
require_relative "board.rb"

class Game
  attr_reader :board, :incorrect_guesses
  def initialize 
    @word = pick_word.downcase
    @board = Board.new(@word)
    @incorrect_guesses = []
  end

  def play
    round = 0
    game_rule
    loop do
      update_display
      if game_over?
        game_over_message
        return
      end
      if round > 0 
        if save? == "2"
          save_game
          return
        end
      end
      round += 1
      solicit_guess
      update_result(get_letter)
    end
  end

  private

  def pick_word
    words = File.readlines "dictionary.txt"
    word = ""
    word = words[rand(words.length)].strip until word.length >= 5 && word.length <= 12
    word
  end

  def game_rule
    puts "Guess my secret word."  
    puts "Pick a letter and I'll let you know if the secret word contains it." 
    puts "If you find the secret word before making 6 incorrect guess, you win."
    puts "If not, I win... :)"
  end

  def update_display
    sleep(2)
    board.show_status
    sleep(2)
    puts "Incorrect Letter(s): #{incorrect_guesses.join(", ")}"
    puts "#{incorrect_guesses.length} incorrect guess(es) made\n(Remember, 6 incorrect guesses and you lose!)\n\n"
    sleep(2)
    
  end

  def solicit_guess
    puts "Go ahead type one letter that you think it might be in the secret word and hit enter."
  end

  def get_letter
    loop do 
      letter = gets.strip.downcase
      return letter if valid_input?(letter)
    end
  end

  def valid_input? (input)
    if incorrect_guesses.include?(input) || board.letters.include?(input)
      puts "\nThe letter has been previously entered.  Please select other letter."
      return false
    elsif !input.match(/^[a-z]{1}$/)
      puts "\nPlease enter one alphabet letter"
      return false
    end
    true
  end

  def match_indices (input)
    @word.split("").each_index.select { |index| @word[index] == input }
  end

  def feedback (match)
    puts match ? "\nYou found the matching letter for the secret word!" : "\nThe letter you entered doesn't match any letter of the secret word..."
  end

  def update_result(letter)
    match = false
    if match_indices(letter).length > 0  
      board.set_letter(letter, match_indices(letter)) 
      match = true
    else
      incorrect_guesses << letter
    end
    feedback(match)
  end

  def game_over?
    return :win if board.player_win?
    return :lose if incorrect_guesses.length == 6
    false
  end

  def game_over_message
    puts "You guessed the word correctly. You won!" if game_over? == :win
    puts "You lose... The secret word was #{@word}"  if game_over? == :lose
  end

  def save?
    puts "Do you want to save the game to play later?"
    puts "1: Continue\t2: Save"
    loop do 
      answer = gets.chomp
      return answer if answer.match(/^[12]$/)
      puts "Please select 1 to continue or 2 to save the game and quit and hit enter."
    end
  end

  def save_game
    puts "Please enter the game name that you want to save under."
    file_name = gets.strip
    while file_name.match(/[\W\s]/) || file_name == ""
      puts "you can use only alphabet, numbers and underscore for the name"
      file_name = gets.strip
    end
    yaml = YAML::dump(self)
    File.open("saved/#{file_name}.yaml", "w") { |file| file.write(yaml)}
  end
end

