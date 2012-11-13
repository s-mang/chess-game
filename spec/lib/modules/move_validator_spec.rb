require File.expand_path('../../../spec_helper.rb', __FILE__)
require File.expand_path('../../../../lib/game.rb', __FILE__)
require File.expand_path('../../../../lib/modules/constants.rb', __FILE__)
require File.expand_path('../../../../lib/modules/move_validator.rb', __FILE__)

include Constants

describe MoveValidator do
  class DummyClass
  end

  let(:game) { Game.new }
  subject(:dummy) { (DummyClass.new).extend MoveValidator }

  # Check for stationary math (non-move)
  context '#is_non_stationary_path?' do
    it { dummy.is_non_stationary_path?([1,1], [1,1]).should be_false }  
    it { dummy.is_non_stationary_path?([1,2], [1,3]).should be_true }
  end

  # X & Y distances
  context '#x_and_y_distances' do
    it { dummy.x_and_y_distances([1,1], [3,3]).should == [2,2] }
  end

  # Total distance
  context '#total_dist' do
    def stub_methods_and_call_total_dist(from, to, stub_return)
      dummy.stub(:x_and_y_distances).with(from, to).and_return(stub_return)
      dummy.total_dist(from, to)
    end
    
    it { stub_methods_and_call_total_dist([1,1], [3,3], [2,2]).should == 2 }
    it { stub_methods_and_call_total_dist([1,1], [3,2], [2,1]).should == -1 }
    it { stub_methods_and_call_total_dist([1,1], [1,3], [0,2]).should == 2 }
  end

  # Forward paths
  context '#is_forward_path?' do
    it { dummy.is_forward_path?([3,1], [1,1], SECOND_PLAYER).should be_true } 
    it { dummy.is_forward_path?([1,1], [3,1], FIRST_PLAYER).should be_true }
    it { dummy.is_forward_path?([3,1], [1,1], FIRST_PLAYER).should be_false }
  end

  # Perpendicular paths
  context '#is_perpendicular_path?' do
    def stub_methods_and_call_is_perp_path(from, to, stub_return)
      dummy.stub_chain(:is_non_stationary_path?, :x_and_y_distances).with(from, to).and_return(stub_return)
      dummy.is_perpendicular_path?(from, to)
    end
      
    it { stub_methods_and_call_is_perp_path([1,1], [4,1], [3,0]).should be_true }
    it { stub_methods_and_call_is_perp_path([1,1], [3,2], [2,1]).should be_false }
  end

  # L paths
  context '#is_L_path?' do
    def stub_methods_and_call_is_L_path(from, to, stub_return)
      dummy.stub(:x_and_y_distances).with(from, to).and_return(stub_return)
      dummy.is_L_path?(from, to)
    end
    
    it { stub_methods_and_call_is_L_path([1,1], [3,5], [2,4]).should be_false }
    it { stub_methods_and_call_is_L_path([1,1], [3,2], [2,1]).should be_true }
  end

  # Diagonal paths
  context '#is_diagonal_path?' do
    def stub_methods_and_call_is_diagonal_path(from, to, stub_return)
      dummy.stub(:x_and_y_distances).with(from, to).and_return(stub_return)
      dummy.is_diagonal_path?(from, to)
    end
    
    it { stub_methods_and_call_is_diagonal_path([1,1], [3,2], [2,1]).should be_false }
    it { stub_methods_and_call_is_diagonal_path([1,1], [3,3], [2,2]).should be_true }
  end

  # Get squares between from and to (get path squares)
  context '#get_path_squares' do
    def stub_methods_and_call_get_path_squares(from, to, stub_return_1, stub_return_2)
      dummy.stub(:x_and_y_distances).with(from, to).and_return(stub_return_1)
      dummy.stub(:is_diagonal_path?).with(from, to).and_return(stub_return_2)
      dummy.get_path_squares(from, to)
    end
    
    it { stub_methods_and_call_get_path_squares([1,1],[3,3],[2,2], true).should == [[2,2]]}
  end

  # Vacant paths
  context '#is_vacant_path?' do
    def stub_methods_and_call_is_vacant_path(from, to, stub_return)
      dummy.stub_chain(:is_straight_path?, :get_path_squares).with(from, to).and_return(stub_return)
      dummy.is_vacant_path?(from, to, game.board)
    end
    
    it { stub_methods_and_call_is_vacant_path([3,0], [5,0], [[2,2]]).should be_true }
    it { stub_methods_and_call_is_vacant_path([0,0], [0,2], [[0,2]]).should be_false }
  end

  # Straight paths
  context '#is_straight_path?' do
    def stub_methods_and_call_is_straight_path(from, to, stub_return)
      dummy.stub_chain(:is_diagonal_path?, :is_perpendicular_path?).with(from, to).and_return(stub_return)
      dummy.is_straight_path?(from, to)
    end
    
    it { stub_methods_and_call_is_straight_path([1,1], [2,3], false).should be_true }
    it { stub_methods_and_call_is_straight_path([1,1], [1,3], true).should be_true }
    it { stub_methods_and_call_is_straight_path([1,1], [3,3], true).should be_true }
  end

  # All piece movements

  # Valid pawn movements
  context '#is_valid_pawn_distance?' do
    def stub_methods_and_call_is_straight_path(from, to, stub_return_1, stub_return_2)
      dummy.stub(:total_dist).with(from, to).and_return(stub_return_1)
      game.board.stub(:piece_has_moved?).with(from).and_return(stub_return_2)
      dummy.is_valid_pawn_distance?(from, to, game.board)
    end
    
    it { stub_methods_and_call_is_straight_path([1,2], [3,2], -1, false).should be_false } 
    it { stub_methods_and_call_is_straight_path([1,2], [3,1], 2, true).should be_false } 
    it { stub_methods_and_call_is_straight_path([1,2], [2,1], 2, false).should be_true }
    it { stub_methods_and_call_is_straight_path([1,1], [3,1], 2, false).should be_true } 
  end   

  context '#is_valid_path?' do
    # Pawn path
    it "should recognize an invalid path for a pawn" do
      game.board.stub(:piece_at?).with([6,7]).and_return(true)
      dummy.stub(:is_diagonal_path).with([1,5], [6,7]).and_return(false)
      dummy.is_valid_path?([1,5], [6,7], game.board, FIRST_PLAYER).should be_false
    end

    # Rook path
    it "should recognize an invalid path for a rook" do
      rook_location = PIECES[:back_row].index('rook')
      dummy.stub(:is_perpendicular_path?).with([0,rook_location], [1, rook_location]).and_return(true)
      dummy.stub(:is_vacant_path?).with([0,rook_location],[1,rook_location], game.board).and_return(false)
      dummy.is_valid_path?([0, rook_location], [1, rook_location], game.board, FIRST_PLAYER ).should be_false
    end

    # Knight path
    it "should recognize an invalid path for a knight" do
      knight_location = PIECES[:back_row].index('knight')
      dummy.stub(:is_L_path).with([0,knight_location], [1, knight_location]).and_return(false)
      dummy.is_valid_path?([0, knight_location], [1, knight_location], game.board, FIRST_PLAYER ).should be_false
    end

    # Bishop path
    it "should recognize an invalid path for a bishop" do
      bishop_location = PIECES[:back_row].index('bishop')
      game.board.stub(:is_diagonal_path?).with([0, bishop_location], [1, bishop_location]).and_return(false)
      dummy.is_valid_path?([0, bishop_location], [1, bishop_location], game.board, FIRST_PLAYER ).should be_false
    end

    # Queen path
    it  "should recognize an invalid path for a queen" do
      queen_location = PIECES[:back_row].index('queen')
      game.board.stub(:is_straight_path).with([0,queen_location], [3, queen_location + 1]).and_return(false)
      dummy.is_valid_path?([0, queen_location], [3, (queen_location + 1)], game.board, FIRST_PLAYER ).should be_false
    end

    # King path
    it "should recognize an invalid path for a king" do
      king_location = PIECES[:back_row].index('king')
      game.board.stub_chain(:is_straight_path?, :total_dist).with([0, king_location], [3, king_location]).and_return(3)
      dummy.is_valid_path?([0, king_location], [3, king_location], game.board, FIRST_PLAYER ).should be_false
    end
  end

  # Board position
  context '#is_on_board?' do
    it { dummy.is_on_board?([-1,5]).should be_false }
  end

  # Piece captures
  context '#can_capture_piece?' do
    def stub_methods_and_call_can_capture_piece(capturer, captured, x, y, stub_return)
      game.board.stub_chain(:piece_at?, :piece_owned_by?).with(capturer, x, game.board).and_return(stub_return)
      dummy.can_capture_piece?([x, y], game.board, captured)
    end
      
    it { stub_methods_and_call_can_capture_piece(FIRST_PLAYER, SECOND_PLAYER, FIRST_PLAYER[:owns][:front_row], (YMAX / 2).round, false).should be_true }
  end

  context '#piece_owned_by?' do
    it { dummy.piece_owned_by?(FIRST_PLAYER, [FIRST_PLAYER[:owns][:back_row], 0], game.board) }
  end

  # Getting errors for move (if any)
  context '#get_errors_for_move' do
    def stub_methods_and_call_get_errors_for_move(from, to, player, stub_return_1, stub_return_2, stub_return_3 = nil)
      game.board.stub_chain(:piece_at?, :is_on_board?).with(to).and_return(stub_return_1)
      game.stub_chain(:piece_owned_by?, :is_valid_path?).with(from, to, game.board, player).and_return(stub_return_2)
      game.board.stub(:piece_at?).with(to).and_return(stub_return_3) unless stub_return_3.nil?
      dummy.get_errors_for_move(from, to, game.board, player)
    end
    
    it { stub_methods_and_call_get_errors_for_move([1,1], [2,1], FIRST_PLAYER, true, true, false).should be_nil } 
    it { stub_methods_and_call_get_errors_for_move([XMAX,YMAX], [0,0], FIRST_PLAYER, true, false).should be_a_kind_of(String) } 
    it { stub_methods_and_call_get_errors_for_move([0,0], [XMAX,YMAX], FIRST_PLAYER, true, false).should be_a_kind_of(String) } 
  end
end