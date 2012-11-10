require File.expand_path('../../spec_helper.rb', __FILE__)
require File.expand_path('../../../lib/board.rb', __FILE__)
require File.expand_path('../../../lib/modules/constants.rb', __FILE__)

include Constants
describe Board do
  subject(:board) { Board.new }
  
  ## INITIAL:
  # First player:
  it "has all player1's pawns in row #{FIRST_PLAYER[:owns][:front_row]}" do
    board.pieces[FIRST_PLAYER[:owns][:front_row]].each do |piece|
      piece.name.should == PIECES[:front_row_piece]
      piece.color.should == FIRST_PLAYER[:color]
    end
  end
  
  it "has all player1's other pieces in row #{FIRST_PLAYER[:owns][:back_row]}" do
    count = 0
    board.pieces[FIRST_PLAYER[:owns][:back_row]].each do |piece|
      piece.name.should == PIECES[:back_row][count]
      piece.color.should == FIRST_PLAYER[:color]
      count += 1
    end
  end
  
  # Second player:
  it "has all player2's pawns in row #{SECOND_PLAYER[:owns][:front_row]}" do
    board.pieces[SECOND_PLAYER[:owns][:front_row]].each do |piece|
      piece.name.should == PIECES[:front_row_piece]
      piece.color.should == SECOND_PLAYER[:color]
    end
  end
  
  it "has all player2's other pieces in row #{SECOND_PLAYER[:owns][:back_row]}" do
    count = 0
    board.pieces[SECOND_PLAYER[:owns][:back_row]].each do |piece|
      piece.name.should == PIECES[:back_row][count]
      piece.color.should == SECOND_PLAYER[:color]
      count += 1
    end
  end
  
  
  # PIECE_AT?: 
  context '#piece_at' do 
    it { board.piece_at?(FIRST_PLAYER[:owns][:back_row],0).should be_true }  
    it { board.piece_at?((XMAX/2).round, 0).should be_false }
  end

    
   
end