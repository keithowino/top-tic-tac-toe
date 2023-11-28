

# ? COMMAND LINE TIC TAC TOE

# Canvas delt with

class Canvas
  attr_accessor :slots

  def initialize
    @slots = Array.new(9, "-")
  end

  def canvas_build
    canvas = ""
    (0..8).step(3) do |i|
      canvas += "| #{@slots[i]} | #{@slots[i + 1]} | #{@slots[i + 2]} |\n"
    end
    puts "#{canvas}\n\n"
  end

  def place_character(position, character) # * Places a character at a specified position
    @slots[position] = character
  end

  def space_taken?(position)
    return @slots[position] == "X" || @slots[position] == "O"
  end
end

# Engine delt with

class Engine
  attr_accessor :player1, :player2, :turn, :board

  @@close = [
    [0, 1, 2], 
    [3, 4, 5], 
    [6, 7, 8],
    [0, 3, 6], 
    [1, 4, 7], 
    [2, 5, 8], 
    [0, 4, 8], 
    [2, 4, 6]
  ]

  def initialize(player1, player2, board)
    @player1 = player1
    @player2 = player2
    @board = board

    # * Information for current transmition

    @current_turn = 1
    @first_turn = ""
    @winner = ""

    engine_start
  end

  def engine_start # * The main transmition flow
    pick_first_turn
    player_mark
    take_turns
  end

  private

  def pick_first_turn # * A player is randomly chosen to go first
    placeholder = %w(first second).sample
    first_turn = placeholder

    case first_turn
    when "first"
      @first_turn = @player1.name
    when "second"
      @first_turn = @player2.name
    end
  end

  def player_mark # Allocate characters to the players.
    @player1.sym = "X"
    @player2.sym = "O"
  end

  def take_turns # * Loops between the players depending on who started first & the current turn number.
    until draw? || @winner != ""
      if @first_turn == @player1.name
        (@current_turn.even?) ? turn(@player2) : turn(@player1)
      else @first_turn == @player2.name
        (@current_turn.even?) ? turn(@player1) : turn(@player2)
      end
    end
    puts "Game was a draw" if draw? # * Checks if the game is a draw after loop ends.
    # @board.repeat_interval if draw?
  end

  def turn(player) # * One turn for a player.
    puts "Turn #{@current_turn}: "
    puts "\n"
    @board.canvas_build
    @board.place_character(get_valid_position(player), player.sym)
    announce_win(player)
    @current_turn += 1
  end

  def get_valid_position(player) # * Gets valid input from player.
    input = 0
    until valid_input?(input)
      puts "#{player.name}, Enter the cell number that you would like to occupy (1 - 9): "
      puts "\n"
      input = gets.chomp.to_i
      puts "\n"
      puts "Invalid input! " unless valid_input?(input)
      puts "Number is not in range (1 - 9) " unless (input > 0 && input < 10)
      puts "Cell occupied" if @board.space_taken?(input - 1)
    end
    input -= 1
  end

  def announce_win(player)
    check_winner(player)
    if @winner == player.name
      puts "#{player.name} is the winner!"
    end
  end

  def draw? # * Checks if the game is a draw.
    (@current_turn == @board.slots.size) && (@winner == "")
  end

  def check_winner(player)
    @@close.each do |tagged|
      @winner = player.name if tagged.all? { |slot| @board.slots[slot] == player.sym}
    end
  end

  def valid_input?(input)
    return input > 0 && input < 10 && !@board.space_taken?(input - 1)
  end
end

# Opponent delt with

class Opponent
  attr_accessor :name, :sym

  def initialize(name)
    @name = name
  end
end

# Curtains delt with

class Curtains
  attr_accessor :opponenta, :opponentb

  def initialize

    welcome_players

    intervals
  end

  def welcome_players # * greets players, asks for names
    puts "\n"
    puts "\t\t|================================|"
    puts "\t\t|==== WELCOME TO TIC TAC TOE ====|"
    puts "\t\t|================================|"
    puts "\n\n"
    puts "If you may, player 1 would you please state your pseudo name bellow, thank you: "
    puts "\n"
    @opponenta = gets.chomp
    puts "\n"
    puts "Likewise player 2, we appreciate your punctuality: "
    puts "\n"
    @opponentb = gets.chomp
    puts "\n"
    puts "..."

    sleep 3

    puts "\n"
    puts "Welcome players let's begin..."
    puts "\n"
  end

  def intervals # * Would eventualy loop between running the game and asking if user want to play again.
    initialize_interval

    repeat_interval
  end

  def initialize_interval # * creates and runs a game.
    board = Canvas.new
    player1, player2 = Opponent.new(@opponenta), Opponent.new(@opponentb)
    game = Engine.new(player1, player2, board)
  end

  def repeat_interval
    input = nil
    until input == "YES" or input == "NO"
      puts "Would you like to play again (YES/ NO): "
      puts "\n"
      input = gets.chomp.upcase
      puts "\n"
    end

    case input
    when "YES"
      initialize_interval
    when "NO"
      puts "Thank you for playing"
    end
  end
end

Curtains.new