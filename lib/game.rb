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
  
  def game_over?
    @game_over
  end
  
  # CAPTURES & RETURNS CAPTURED PIECE BY CURRENT_PLAYER
  def make_captures(to)
    unless (piece = @board.piece_at(to)).zero?
      if @current_player == FIRST_PLAYER
        @first_player_captured_pieces << piece
      else
        @second_player_captured_pieces << piece
      end    
    end
    return piece
  end
  
  # CHANGE POSITION OF (FROM) PIECE TO (TO)
  def update_board(from, to)
    @board.set_piece(to, @board.piece_at(from))
    @board.set_piece(from, 0)
  end
  
  # CONTROLLS MOVE-MAKING & CHECKS FOR GAME OVER
  def make_move(from, to)
    error_messages = get_errors_for_move(from, to, @board, @current_player)
    if error_messages.is_a?(String)
      puts error_messages
      return false
    else
      piece = make_captures(to)
      if piece.nonzero? && (piece.name == "king")
        @game_over = true
      end
      moving_piece = @board.piece_at(from)
      update_board(from, to)
      @board.set_piece_as_moved(moving_piece)
      return true
    end
  end
end