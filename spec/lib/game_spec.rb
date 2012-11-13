require File.expand_path('../../spec_helper.rb', __FILE__)
require File.expand_path('../../../lib/game.rb', __FILE__)
require File.expand_path('../../../lib/modules/constants.rb', __FILE__)

include Constants

describe Game do
  subject(:game) { Game.new }
  
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
    let!(:pawn) { game.board.pieces[1][5] }
    
    def stub_methods_and_call_make_move(from, to, player, stub_returns = {})
      game.stub(:get_errors_for_move).with(from, to, game.board, player).and_return(stub_returns[:first])
      game.stub(:make_captures).with(to).and_return(stub_returns[:second]) unless stub_returns[:second].nil?
      game.make_move(from, to)
    end
          
    it { stub_methods_and_call_make_move([1,3], [-2,5], FIRST_PLAYER, { :first => "This is an error message" }).should be_false }   
    it { stub_methods_and_call_make_move([1,1], [2,1], FIRST_PLAYER, { :second => 0 }).should be_true }    
    it { expect { stub_methods_and_call_make_move([1,5], [2,1], FIRST_PLAYER, { :second => 0 }) }.
        to change { pawn.has_moved? }.from(false).to(true) }
           
    ## END GAME?
    it { expect { stub_methods_and_call_make_move([1,1], [SECOND_PLAYER[:owns][:back_row], PIECES[:back_row].index("king")], FIRST_PLAYER) }.to change { game.game_over? }.from(false).to(true) }
  end
  
  ## UPDATE BOARD
  context '#update_board' do
    it { expect { game.update_board([1,1], [2,1]) }.to change { game.board.pieces[1][1] }.to(0) }
  end
  
  ## PIECE CAPTURE
  context '#make_captures' do
    let!(:queen) { game.board.pieces[SECOND_PLAYER[:owns][:back_row]][PIECES[:back_row].index("queen")] }
    
    it { expect { game.make_captures([SECOND_PLAYER[:owns][:front_row], 0])}.to change { game.first_player_captured_pieces.length }.by(1) }  
    it { game.make_captures([SECOND_PLAYER[:owns][:back_row], PIECES[:back_row].index("queen")]).should equal(queen) }  
  end
   
end