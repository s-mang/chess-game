require File.expand_path('../../spec_helper.rb', __FILE__)
require File.expand_path('../../../lib/piece.rb', __FILE__)
describe Piece do
  subject(:piece) { Piece.new("pawn", "white") }
  
  ## INITIAL:
  it { piece.name.should == "pawn" }
  it { piece.color.should == "white"}
  it { piece.has_moved.should be_false }

  ## MOVE PIECE:
  it { expect { piece.move }.to change { piece.has_moved }.from(false).to(true) }
  
end