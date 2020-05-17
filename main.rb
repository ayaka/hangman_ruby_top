require_relative "lib/game.rb"
require "yaml"

def select_game
  files = Dir["saved/*.yaml"].map { |path| File.basename(path, ".yaml") }
  return "new" if files == []
  file_name = ""
  unless files.include?(file_name) || file_name == "new"
    puts "If you want to play new game, please type new and hit enter."
    puts "If you want to play saved game, please type saved game name and hit enter"
    puts "Saved game(s):  #{files.join("\t")}"
    file_name = gets.strip.downcase
  end
  file_name
end

selection = select_game
if selection == "new"
  game = Game.new
  game.play
else
  saved_game = YAML.load(File.read("saved/#{selection}.yaml"))
  puts "Quick reminder of the rule..."
  saved_game.play
end

