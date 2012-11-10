require File.expand_path('../../game.rb', __FILE__)

module MoveValidator
  
  # METHODS TO GET DISTANCE BETWEEN TWO SQUARES
  def x_and_y_distances(from, to)
    return [(from[0] - to[0]).abs, (from[1] - to[1]).abs]
  end

  def total_dist(from, to)
    dists = x_and_y_distances(from, to)
    if dists.include?(0)
      return (dists[0] + dists[1])
    elsif dists[0] == dists[1]
      return dists[0]
    else
      return -1 # not a valid (straight) path
    end
  end
  
  # VALIDITY CHECKERS FOR PATH
  def is_non_stationary_path?(from, to)
    return !((from[0] == to[0]) && (from[1] == to[1]))
  end

  def is_valid_pawn_distance?(from, to, board)
    return ((total_dist(from,to) == 1) || (total_dist(from, to) == 2 && !(board.piece_has_moved?(from))))
  end

  def is_forward_path?(from, to, player)
    if player[:owns][:back_row].zero? 
      return (from[0] < to[0])
    else
      return (from[0] > to[0])
    end
  end

  def is_perpendicular_path?(from, to)
    return is_non_stationary_path?(from,to) && x_and_y_distances(from,to).include?(0)
  end

  def is_L_path?(from, to)
    return (dists = x_and_y_distances(from, to)).include?(1) && dists.include?(2)
  end

  def is_diagonal_path?(from, to)
    return (x_and_y_distances(from, to).uniq.length == 1)
  end

  def is_straight_path?(from, to)
    return (is_diagonal_path?(from, to) || is_perpendicular_path?(from, to))
  end

  def is_vacant_path?(from, to, board)
    if board.piece_at?(to[0], to[1])
      return false
    else 
      get_path_squares(from, to).each do |coord|
        if board.piece_at?(coord[0], coord[1])
          return false
        end
      end
    end
    return true 
  end

  # RETURNS AN ARRAY OF COORDINATES OF SQUARES IN THE PATH BETWEEN (FROM) AND (TO)
  def get_path_squares(from, to)
    total_dist = total_dist(from, to)
    coords = []
    (total_dist - 1).times do |dist|
      if is_diagonal_path?(from, to)
        coords << [(from[0] + dist + 1), (from[1] + dist + 1)]
      elsif (from[0] == to[0]) # if move is along y-axis
        coords << [from[0], (from[1] + dist + 1)]
      else # if move is along x-axis
        coords << [(from[0] + dist + 1), from[1]]
      end
    end
    return coords
  end

  # CHECKS IF SQUARE IS ON THE BOARD
  def is_on_board?(to)
    return ((to[0] < XMAX) && (to[1] < YMAX) && (to[0] > 0) && (to[1] > 0))
  end

  # CONTROLS VALIDITY CHECK OF MOVE/PATH
  def is_valid_path?(from, to, board, current_player)
    case board.pieces[from[0]][from[1]].name
    when "king" 
      return (is_straight_path?(from, to) && (total_dist(from, to) == 1))
    when "queen"
      return (is_straight_path?(from, to) && is_vacant_path?(from, to, board))
    when "bishop"
      return (is_diagonal_path?(from, to) && is_vacant_path?(from, to, board))
    when "knight" 
      return is_L_path?(from, to)
    when "rook"
      return (is_perpendicular_path?(from, to) && is_vacant_path?(from, to, board))
    when "pawn"    
      if board.piece_at?(to[0], to[1])
       return (is_diagonal_path?(from, to) && (total_dist(from, to) == 1))
      else
        return (is_perpendicular_path?(from, to) && is_forward_path?(from, to, current_player) && is_valid_pawn_distance?(from, to, board))
      end
    end
    return false # if called with another piece name
  end 
  
  # CHECKS IF PIECE CAN BE CAPTURED
  def can_capture_piece?(to, board, current_player)
    return ((board.piece_at?(to[0], to[1])) && (!piece_owned_by?(current_player, [to[0], to[1]], board)))
  end 
  
  # CHECKS IF PIECE IS OWNED BY (CURRENT_PLAYER)
  def piece_owned_by?(current_player, loc, board)
    return (board.pieces[loc[0]][loc[1]].color == current_player[:color])
  end
  
  # RETURNS THE ERROR MESSAGES FOR MOVE (OR NIL IF NO ERRORS)
  def get_errors_for_move(from, to, board, current_player)   
    return "No piece at #{from[0]}, #{from[1]}" unless (board.piece_at?(from[0], from[1]))
    return "That move is off the board." unless is_on_board?(to)
    return "That is not your piece to move." unless piece_owned_by?(current_player, from, board)
    return "That piece cannot move to #{to[0]}, #{to[1]}" unless is_valid_path?(from, to, board, current_player)
    return "You cannot capture the piece at #{to[0]}, #{to[1]}" unless !board.piece_at?(to[0], to[1]) || can_capture_piece?(to, board, current_player)
  end
  
  
  
  
  
  
end