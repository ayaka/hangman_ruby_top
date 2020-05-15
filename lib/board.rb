class Board
  attr_reader :letters
  def initialize(word)
    @letters = []
    word.length.times { @letters << "_"}
  end

  def show_status

    puts "\n\t" + letters.join("\s")
    puts ''
  end

  def set_letter(letter, indices)
    indices.each { |i| letters[i] = letter }
  end

  def player_win?
    return true if !letters.include?("_")
    false
  end
end

