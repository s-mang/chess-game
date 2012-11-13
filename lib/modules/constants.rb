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


module Constants  
  # Board pieces
  PIECES = { :back_row => ["rook", "knight", "bishop", "queen", "king", "bishop", "knight", "rook"],
             :front_row_piece => "pawn" }
             
  # Board maximum length & width
  # Pieces start along the x-axis
  XMAX = 8
  YMAX = 8
  
  # Players and their color
  # Colors: String
  # Sides: Hash
  FIRST_PLAYER = { :color => "white", :owns => {:back_row =>0, :front_row => 1} }
  SECOND_PLAYER = { :color => "black", :owns => {:back_row => 7, :front_row => 6} }
  
end