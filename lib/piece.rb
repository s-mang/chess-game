require File.expand_path('../board.rb', __FILE__)

class Piece < Board
  attr_accessor :has_moved
  attr_reader :name, :color
  
  def initialize(name, color)
    @name = name
    @color = color
    @has_moved = false
  end
  
  # TO MARK PIECE AS MOVED/UNMOVED
  def move
    @has_moved = true
  end
  
  def unmove
    @has_moved = false
  end
  
  # FOR COMPARING WITH 0 (NON-PIECES are 0)
  def zero?
    return false
  end
  
end