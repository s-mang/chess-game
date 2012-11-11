module AllBe
  class Matcher
    def initialize(color, pieces, board_size)
      @color = color
      @pieces = pieces.is_a?(Array) ? pieces : Array.new(board_size, pieces)
    end

    def matches?(objects)
      count = 0
      objects.each do |obj|
        obj.name == @pieces[count]
        obj.color == @color
        count += 1
      end
    end 
  end

  def all_be(color, pieces, board_size)
    Matcher.new(color, pieces, board_size)
  end 
end

Rspec.configure do |config|
  config.include AllBe
end
