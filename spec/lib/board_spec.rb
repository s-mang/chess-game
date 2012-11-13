require File.expand_path('../../spec_helper.rb', __FILE__)
require File.expand_path('../../../lib/board.rb', __FILE__)
require File.expand_path('../../../lib/modules/constants.rb', __FILE__)
require File.expand_path('../../support/all_be.rb', __FILE__)

include Constants
describe Board do
  subject(:board) { Board.new }
  
  ## INITIAL:
  # First player:
  it "has all player1's pawns in row #{FIRST_PLAYER[:owns][:front_row]}" do
    board.pieces[FIRST_PLAYER[:owns][:front_row]].should all_be(FIRST_PLAYER[:color], PIECES[:front_row_piece], YMAX)
  end
  
  it "has all player1's other pieces in row #{FIRST_PLAYER[:owns][:back_row]}" do
    board.pieces[FIRST_PLAYER[:owns][:back_row]].should all_be(FIRST_PLAYER[:color], PIECES[:back_row], YMAX)
  end
  
  # Second player:
  it "has all player2's pawns in row #{SECOND_PLAYER[:owns][:front_row]}" do
    board.pieces[SECOND_PLAYER[:owns][:front_row]].should all_be(SECOND_PLAYER[:color], PIECES[:front_row_piece], YMAX)
  end
  
  it "has all player2's other pieces in row #{SECOND_PLAYER[:owns][:back_row]}" do
    board.pieces[SECOND_PLAYER[:owns][:back_row]].should all_be(SECOND_PLAYER[:color], PIECES[:back_row], YMAX)
  end
  
  
  context '#piece_at?' do 
    it { board.piece_at?([FIRST_PLAYER[:owns][:back_row],0]).should be_true }  
    it { board.piece_at?([(XMAX/2).round, 0]).should be_false }
  end
  
  context '#piece_at' do
    it { board.piece_at([0,0]).should be_an_instance_of(Piece) }
  end
  
  context '#set_piece' do
    let!(:piece) { Piece.new("king", "white") }
    it { expect { board.set_piece([0,0], piece) }.to change { board.piece_at([0,0]) }.to(piece) }
  end
  
  context '#set_piece_as_moved' do
    let(:piece) { Piece.new("king", "white", false) }
    it { expect { board.set_piece_as_moved(piece) }.to change { piece.has_moved? }.to(true) }
  end
  
  context '#set_piece_as_unmoved' do
    let(:piece) { Piece.new("king", "white", true) }
    it { expect { board.set_piece_as_unmoved(piece) }.to change { piece.has_moved? }.to(false) }
  end
  

    
   
end