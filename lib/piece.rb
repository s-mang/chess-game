require File.expand_path('../board.rb', __FILE__)

class Piece < Board
  attr_accessor :has_moved
  attr_reader :name, :color
  
  def initialize(name, color, has_moved = nil)
    @name = name
    @color = color
    @has_moved = has_moved || false
  end
  
  # FOR COMPARING WITH 0 (NON-PIECES are 0)
  def zero?
    return false
  end
  
  def nonzero?
    return true
  end
  
  # TO MARK PIECE AS MOVED/UNMOVED
  def set_as_moved
    @has_moved = true
  end
  
  def set_as_unmoved
    @has_moved = false
  end
  
  # CHECK IF HAS_MOVED
  def has_moved?
    @has_moved
  end
  
end