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
    piece
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
      false
    else
      piece = make_captures(to)
      if piece.nonzero? && (piece.name == "king")
        @game_over = true
      end
      moving_piece = @board.piece_at(from)
      update_board(from, to)
      @board.set_piece_as_moved(moving_piece)
      true
    end
  end
  
  # CONTROLS VALIDITY CHECK OF MOVE/PATH
  def is_valid_path?(from, to, board, current_player)
    case board.piece_at(from).name
    when "king" 
      (is_straight_path?(from, to) && (total_dist(from, to) == 1))
    when "queen"
      (is_straight_path?(from, to) && is_vacant_path?(from, to, board))
    when "bishop"
      (is_diagonal_path?(from, to) && is_vacant_path?(from, to, board))
    when "knight" 
      is_L_path?(from, to)
    when "rook"
      (is_perpendicular_path?(from, to) && is_vacant_path?(from, to, board))
    when "pawn"    
      if board.piece_at?(to)
        (is_diagonal_path?(from, to) && (total_dist(from, to) == 1))
      else
        (is_perpendicular_path?(from, to) && is_forward_path?(from, to, current_player) && is_valid_pawn_distance?(from, to, board))
      end
    end
    false # if called with another piece name
  end

  # RETURNS THE ERROR MESSAGES FOR MOVE (OR NIL IF NO ERRORS)
  def get_errors_for_move(from, to, board, current_player)   
    "No piece at #{from[0]}, #{from[1]}" unless (board.piece_at?(from))
    "That move is off the board." unless is_on_board?(to)
    "That is not your piece to move." unless piece_owned_by?(current_player, from, board)
    "That piece cannot move to #{to[0]}, #{to[1]}" unless is_valid_path?(from, to, board, current_player)
    "You cannot capture the piece at #{to[0]}, #{to[1]}" unless !board.piece_at?(to) || can_capture_piece?(to, board, current_player)
  end
end