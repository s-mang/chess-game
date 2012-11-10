require File.expand_path('../modules/constants.rb', __FILE__)
require File.expand_path('../modules/move_validator.rb', __FILE__)
require File.expand_path('../board.rb', __FILE__)

class Game
  include Constants
  include MoveValidator
  attr_accessor :board, :current_player, :game_over, :first_player_captured_pieces,
                :second_player_captured_pieces
  
  def initialize
    @board = Board.new
    @current_player = FIRST_PLAYER
    @game_over = false
    @first_player_captured_pieces = []
    @second_player_captured_pieces = []
  end
  
  # CAPTURES & RETURNS CAPTURED PIECE BY CURRENT_PLAYER
  def make_captures(to)
    unless (piece = @board.pieces[to[0]][to[1]]).zero? 
      if (@current_player == FIRST_PLAYER)
        @first_player_captured_pieces << piece
      else
        @second_player_captured_pieces << piece
      end
    end
    return piece
  end
  
  # CHANGE POSITION OF (FROM) PIECE TO (TO)
  def update_board(from, to)
    @board.pieces[to[0]][to[1]] = @board.pieces[from[0]][from[1]]
    @board.pieces[from[0]][from[1]] = 0
  end
  
  # CONTROLLS MOVE-MAKING & CHECKS FOR GAME OVER
  def make_move(from, to)
    error_messages = get_errors_for_move(from, to, @board, @current_player)
    if !error_messages.nil?
      puts error_messages
      return false
    else
      piece = make_captures(to)
      if !piece.zero? && (piece.name == "king")
        @game_over = true
      end
      update_board(from, to)
      @board.pieces[to[0]][to[1]].move
      return true
    end
  end
end