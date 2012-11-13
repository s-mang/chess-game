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
  
  def piece_has_moved?(from)
    piece = piece_at(from)
    return (piece.is_a?(Piece) && piece.has_moved?)
  end
  
  def piece_at(loc)
    @pieces[loc[0]][loc[1]]
  end
  
  def piece_at?(loc)
    return (piece_at(loc) != 0)
  end
  
  def set_piece(loc, piece)
    @pieces[loc[0]][loc[1]] = piece
  end
 
  def set_piece_as_moved(piece)
    piece.set_as_moved unless piece.zero?
  end
  
  def set_piece_as_unmoved(piece)
    piece.set_as_unmoved unless piece.zero?
  end
  
  
  private
  
  def initialize_pieces
    no_pieces_2D_array = Array.new((XMAX - 4), Array.new(YMAX, 0))
    p1_front_row = new_front_row(PIECES[:front_row_piece], FIRST_PLAYER[:color])
    p1_back_row = new_back_row(PIECES[:back_row], FIRST_PLAYER[:color])
    p2_front_row = new_front_row(PIECES[:front_row_piece], SECOND_PLAYER[:color])
    p2_back_row = new_back_row(PIECES[:back_row], SECOND_PLAYER[:color])
    return [p1_back_row, p1_front_row].concat(no_pieces_2D_array).concat([p2_front_row, p2_back_row])
  end
  
  def new_front_row(piece_name, color)
    return Array.new(YMAX, Piece.new(piece_name, color))
  end
  
  def new_back_row(piece_names, color)
    return (Array.new(YMAX) { |index| Piece.new(piece_names[index], color) })
  end
   
end