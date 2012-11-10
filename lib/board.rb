######### GAME BOARD #########
### player1 ###### player2 ###
#                            #
#   1  1  #  #  #  #  2  2   #
#   1  1  #  #  #  #  2  2   #
#   1  1  #  #  #  #  2  2   #
#   1  1  #  #  #  #  2  2   #
#   1  1  #  #  #  #  2  2   #
#   1  1  #  #  #  #  2  2   #
#   1  1  #  #  #  #  2  2   #
#   1  1  #  #  #  #  2  2   #
#   1  1  #  #  #  #  2  2   #
#                            #
##############################

require File.expand_path('../game.rb', __FILE__)

class Board < Game
  include Constants
  attr_accessor :pieces
  
  def initialize
    @pieces = initialize_pieces
  end
  
  # SETTING UP BOARD
  def initialize_pieces
    no_pieces_2D_array = Array.new((XMAX - 4), Array.new(YMAX, 0))
    p1_front_row = new_front_row(PIECES[:front_row_piece], FIRST_PLAYER[:color])
    p1_back_row = new_back_row(PIECES[:back_row], FIRST_PLAYER[:color])
    p2_front_row = new_front_row(PIECES[:front_row_piece], SECOND_PLAYER[:color])
    p2_back_row = new_back_row(PIECES[:back_row], SECOND_PLAYER[:color])
    return [p1_back_row, p1_front_row].concat(no_pieces_2D_array).concat([p2_front_row, p2_back_row])
  end
  
  # METHODS CALLED BY INITIALIZE:
  def new_front_row(piece_name, color)
    return Array.new(YMAX, Piece.new(piece_name, color))
  end
  
  def new_back_row(piece_names_array, color)
    return (Array.new(YMAX) { |index| Piece.new(piece_names_array[index], color) })
  end
  
  # MOVE/CHECK-MOVED/UNMOVE PIECE
  def piece_has_moved?(from)
    piece = @pieces[from[0]][from[1]]
    return (piece.is_a?(Piece) && piece.has_moved)
  end
  
  def move_piece_at(from)
    piece = @pieces[from[0]][from[1]]
    piece.move unless piece.zero?
  end
  
  def unmove_piece_at(from)
    piece = @pieces[from[0]][from[1]]
    piece.unmove unless piece.zero?
  end
    
   
  # CHECK FOR PIECE AT POSITION (X,Y)
  def piece_at?(x, y)
    return @pieces[x][y] != 0
  end
  
end