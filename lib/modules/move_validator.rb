require File.expand_path('../../game.rb', __FILE__)

module MoveValidator
  
  # METHODS TO GET DISTANCE BETWEEN TWO SQUARES
  def x_and_y_distances(from, to)
    [(from[0] - to[0]).abs, (from[1] - to[1]).abs]
  end

  def total_dist(from, to)
    dists = x_and_y_distances(from, to)
    if dists.include?(0)
      (dists[0] + dists[1])
    elsif dists[0] == dists[1]
      dists[0]
    else
      -1 # not a valid (straight) path
    end
  end
  
  # VALIDITY CHECKERS FOR PATH
  def is_non_stationary_path?(from, to)
    ((from[0] != to[0]) || (from[1] != to[1]))
  end

  def is_forward_path?(from, to, player)
    player[:owns][:back_row].zero? ? (from[0] < to[0]) : (from[0] > to[0])
  end

  def is_perpendicular_path?(from, to)
    is_non_stationary_path?(from,to) && x_and_y_distances(from,to).include?(0)
  end
  
  def is_valid_pawn_distance?(from, to, board)
    ((total_dist(from,to) == 1) || (total_dist(from, to) == 2 && !(board.piece_has_moved?(from))))
  end

  def is_L_path?(from, to)
    (dists = x_and_y_distances(from, to)).include?(1) && dists.include?(2)
  end

  def is_diagonal_path?(from, to)
    (x_and_y_distances(from, to).uniq.length == 1)
  end

  def is_straight_path?(from, to)
    (is_diagonal_path?(from, to) || is_perpendicular_path?(from, to))
  end

  def is_vacant_path?(from, to, board)
    get_path_squares(from, to).each do |coord|
      false if board.piece_at?(coord)
    end
    true 
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
    coords
  end

  # CHECKS IF SQUARE IS ON THE BOARD
  def is_on_board?(to)
    ((to[0] < XMAX) && (to[1] < YMAX) && (to[0] > 0) && (to[1] > 0))
  end
  
  # CHECKS IF PIECE CAN BE CAPTURED
  def can_capture_piece?(to, board, current_player)
    ((board.piece_at?(to)) && (!piece_owned_by?(current_player, [to[0], to[1]], board)))
  end 
  
  # CHECKS IF PIECE IS OWNED BY (CURRENT_PLAYER)
  def piece_owned_by?(current_player, loc, board)
    (board.piece_at(loc).color == current_player[:color])
  end
  
end