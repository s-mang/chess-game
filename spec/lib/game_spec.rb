require File.expand_path('../../spec_helper.rb', __FILE__)
require File.expand_path('../../../lib/game.rb', __FILE__)
require File.expand_path('../../../lib/modules/constants.rb', __FILE__)

include Constants

describe Game do
  subject(:game) { Game.new }
  before do
    game.current_player = FIRST_PLAYER
  end
  
  ## INITIAL:
  context '#initialize' do
    its(:board) { should be_an_instance_of(Board) }  
    its(:current_player) { should be_an_instance_of(Hash) }
    its(:game_over) { should be_false }
    its(:first_player_captured_pieces) { should be_empty }
    its(:first_player_captured_pieces) { should be_an_instance_of(Array) }
    its(:second_player_captured_pieces) { should be_empty }
    its(:second_player_captured_pieces) { should be_an_instance_of(Array) }
  end
  
  ## MAKE A MOVE
  context '#make_move' do
    let(:pawn) { game.board.pieces[1][1] }
    
    it "will not make a move off the board" do
      game.stub(:get_errors_for_move).with([1,1], [-2,5], game.board, FIRST_PLAYER).and_return("This is an error message")
      game.make_move([1,1], [-2,5]).should be_false
    end
    
    it "should update board pieces after move" do
      game.stub(:get_errors_for_move).with([1,1], [2,1], game.board, FIRST_PLAYER)
      game.stub(:make_captures).with([2,1]).and_return(0)
      game.stub(:update_board).with([1,1], [2,1])
      game.make_move([1,1], [2,1]).should be_true
      pawn.has_moved should be_true
    end
        
    ## END GAME?
    it "sets @game_over to true when king is captured" do
      game.stub(:get_errors_for_move)
      expect { game.make_move([1,1], [SECOND_PLAYER[:owns][:back_row], PIECES[:back_row].index("king")]) }.to change {game.game_over}.from(false).to(true)
    end
  end
  
  ## UPDATE BOARD
  context '#update_board' do
    it { expect { game.update_board([1,1], [2,1]) }.to change { game.board.pieces[1][1] }.to(0) }
  end
  
  ## PIECE CAPTURE
  context '#make_captures' do
    let(:queen) { game.board.pieces[SECOND_PLAYER[:owns][:back_row]][PIECES[:back_row].index("queen")] }
    
    it { expect { game.make_captures([SECOND_PLAYER[:owns][:front_row], 0])}.to change { game.first_player_captured_pieces.length }.by(1) }  
    it { game.make_captures([SECOND_PLAYER[:owns][:back_row], PIECES[:back_row].index("queen")]).should equal(queen) }  
  end
   
end