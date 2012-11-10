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
    it "should know diagonal distances" do
      dummy.stub(:x_and_y_distances).and_return([2,2])
      dummy.total_dist([1,1], [3,3]).should == 2 
    end
    it "should know non-straight distances" do
      dummy.stub(:x_and_y_distances).and_return([2,1])
      dummy.total_dist([1,1], [3,2]).should == -1
    end
    it "should know horizontal/vertical distances" do
      dummy.stub(:x_and_y_distances).and_return([0,2])
      dummy.total_dist([1,1], [1,3]).should == 2
    end
  end

  # Forward paths
  context '#is_forward_path?' do
    it { dummy.is_forward_path?([3,1], [1,1], SECOND_PLAYER).should be_true } 
    it { dummy.is_forward_path?([1,1], [3,1], FIRST_PLAYER).should be_true }
    it { dummy.is_forward_path?([3,1], [1,1], FIRST_PLAYER).should be_false }
  end

  # Perpendicular paths
  context '#is_perpendicular_path?' do
    it "should recognize x-axis only path as perpendicular" do
      dummy.stub(:is_non_stationary_path?).with([1,1], [4,1]).and_return(true)
      dummy.stub(:x_and_y_distances).with([1,1], [4,1]).and_return([3,0])
      dummy.is_perpendicular_path?([1,1], [4,1]).should be_true
    end
    it "should recognize L path is not perpendicular" do
      dummy.stub(:is_non_stationary_path?).with([1,1], [3,2]).and_return(true)
      dummy.stub(:x_and_y_distances).with([1,1], [3,2]).and_return([2,1])
      dummy.is_perpendicular_path?([1,1], [3,2]).should be_false
    end
  end

  # L paths
  context '#is_L_path?' do
    it "should recogize a non-L path" do
      dummy.stub(:x_and_y_distances).with([1,1], [3,5]).and_return([2,4])    
      dummy.is_L_path?([1,1], [3,5]).should be_false
    end 
    it "should recognize an L path" do
      dummy.stub(:x_and_y_distances).with([1,1], [3,2]).and_return([2,1])  
      dummy.is_L_path?([1,1], [3,2]).should be_true
    end
  end

  # Diagonal paths
  context '#is_diagonal_path?' do
    it "should recognize a non-diagonal path" do
      dummy.stub(:x_and_y_distances).with([1,1], [3,2]).and_return([2,1])  
      dummy.is_diagonal_path?([1,1], [3,2]).should be_false 
    end
    it "should recognize a diagonal path" do
      dummy.stub(:x_and_y_distances).with([1,1], [3,3]).and_return([2,2])  
      dummy.is_diagonal_path?([1,1], [3,3]).should be_true
    end
  end

  # Get squares between from and to (get path squares)
  context '#get_path_squares' do
    it "should return propper path squares" do
      dummy.stub(:x_and_y_distances).with([1,1], [3,3]).and_return([2,2])
      dummy.stub(:is_diagonal_path?).with([1,1], [3,3]).and_return(true)
      dummy.get_path_squares([1,1], [3,3]).should == [[2,2]]
    end
  end

  # Vacant paths
  context '#is_vacant_path?' do
    it "should recognize vacant path" do
      dummy.stub(:is_straight_path?).with([3,0], [5,0]).and_return(true)
      dummy.stub(:get_path_squares).with([3,0], [5,0]).and_return([[2,2]])
      dummy.is_vacant_path?([3,0], [5,0], game.board).should be_true
    end
    it "should recognize non-vacant path" do
      dummy.stub(:is_straight_path?).with([0,0], [0,2]).and_return(true)
      dummy.stub(:get_path_squares).with([0,0], [0,2]).and_return([[0,1]])
      dummy.is_vacant_path?([0,0], [0,2], game.board).should be_false
    end
  end

  # Straight paths
  context '#is_straight_path?' do
    it "should recognize a non-straight path" do
      dummy.stub(:is_straight_path?).with([1,1], [2,3]).and_return(false)
      dummy.stub(:is_perpendicular_path?).with([1,1], [2,3]).and_return(false)
      dummy.is_straight_path?([1,1], [2,3]).should be_false 
    end
    it "should recognize a straight perpendicular path" do
      dummy.stub(:is_straight_path?).with([1,1], [1,3]).and_return(true)
      dummy.stub(:is_perpendicular_path?).with([1,1], [1,3]).and_return(true)
      dummy.is_straight_path?([1,1], [1,3]).should be_true
    end
    it "should recognize a straight diagonal path" do
      dummy.stub(:is_straight_path?).with([1,1], [3,3]).and_return(true)
      dummy.stub(:is_perpendicular_path?).with([1,1], [3,3]).and_return(true)
      dummy.is_straight_path?([1,1], [3,3]).should be_true
    end
  end

  # All piece movements

  # Valid pawn movements
  context '#is_valid_pawn_distance?' do
    it "should recognize an invalid pawn path (not straight)" do 
      dummy.stub(:total_dist).with([1,2], [3,2]).and_return(-1)
      game.board.stub(:piece_has_moved?).with([1,2]).and_return(true)
      dummy.is_valid_pawn_distance?([1,2], [3,2], game.board).should be_false
    end
    it "should recognize an invalid path distance of 2 for a pawn that has already moved" do
      dummy.stub(:total_dist).with([1,1], [3,1]).and_return(2)
      game.board.stub(:piece_has_moved?).with([1,1]).and_return(true)
      dummy.is_valid_pawn_distance?([1,1], [3,1], game.board).should be_false
    end
    it "should recognize a valid pawn path of distance 1 for a pawn that has already moved" do
      dummy.stub(:total_dist).with([1,1], [2,1]).and_return(2)
      game.board.stub(:piece_has_moved?).with([1,1]).and_return(false)
      dummy.is_valid_pawn_distance?([1,1],[2,1], game.board).should be_true
    end
    it "should recognize a valid path distance of 2 for a pawn that has not already moved" do
      dummy.stub(:total_dist).with([1,1], [3,1]).and_return(2)
      game.board.stub(:piece_has_moved?).with([1,1]).and_return(false)
      dummy.is_valid_pawn_distance?([1,1], [3,1], game.board).should be_true
    end 
  end   

  context '#is_valid_path?' do
    # Pawn path
    it "should recognize an invalid path for a pawn" do
      game.board.stub(:piece_at?).with(6,7).and_return(true)
      game.stub(:is_diagonal_path).with([1,5], [6,7]).and_return(false)
      dummy.is_valid_path?([1,5], [6,7], game.board, FIRST_PLAYER).should be_false
    end

    # Rook path
    it "should recognize an invalid path for a rook" do
      rook_location = PIECES[:back_row].index('rook')
      game.stub(:is_perpendicular_path?).with([0,rook_location],[1,rook_location]).and_return(true)
      game.stub(:is_vacant_path?).with([0, rook_location], [1, rook_location], game.board).and_return(false)
      dummy.is_valid_path?([0, rook_location], [1, rook_location], game.board, FIRST_PLAYER ).should be_false
    end

    # Knight path
    it "should recognize an invalid path for a knight" do
      knight_location = PIECES[:back_row].index('knight')
      game.stub(:is_L_path).with([0,knight_location], [1, knight_location]).and_return(false)
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
      game.board.stub(:is_straight_path?).with([0, king_location], [3, king_location]).and_return(true)
      game.board.stub(:total_dist).with([0, king_location], [3, king_location]).and_return(3)
      dummy.is_valid_path?([0, king_location], [3, king_location], game.board, FIRST_PLAYER ).should be_false
    end
  end

  # Board position
  context '#is_on_board?' do
    it { dummy.is_on_board?([-1,5]).should be_false }
  end

  # Piece captures
  context '#can_capture_piece?' do
    it "should recognize a player/move that can capture the given piece" do
      game.board.stub(:piece_at?).with(FIRST_PLAYER[:owns][:front_row], (YMAX/2).round).and_return(true)
      game.board.stub(:piece_owned_by?).with(FIRST_PLAYER, [FIRST_PLAYER[:owns][:front_row]], game.board).and_return(false)
      dummy.can_capture_piece?([FIRST_PLAYER[:owns][:front_row], (YMAX / 2).round], game.board, SECOND_PLAYER).should be_true
    end 
  end

  context '#piece_owned_by?' do
    it { dummy.piece_owned_by?(FIRST_PLAYER, [FIRST_PLAYER[:owns][:back_row], 0], game.board) }
  end

  # Getting errors for move (if any)
  context '#get_errors_for_move' do
    it "should recognize a valid move" do
      game.board.stub(:piece_at?).with(1,1).and_return(true)
      game.board.stub(:is_on_board?).with([2,1]).and_return(true)
      game.stub(:piece_owned_by?).with(FIRST_PLAYER, [1,1], game.board).and_return(true)
      game.stub(:is_valid_path?).with([1,1], [2,1], game.board, FIRST_PLAYER).and_return(true)
      game.board.stub(:piece_at?).with(2, 1).and_return(false)
      dummy.get_errors_for_move([1,1], [2,1], game.board, FIRST_PLAYER).should be_nil
    end  
    it "should recognize an invalid path" do 
      game.board.stub(:piece_at?).with(0,0).and_return(true)
      game.board.stub(:is_on_board?).with([7,7]).and_return(true)
      game.stub(:piece_owned_by?).with(FIRST_PLAYER, [1,1], game.board).and_return(true)
      game.stub(:is_valid_path?).with([1,1], [7,7], game.board, FIRST_PLAYER).and_return(false)
      dummy.get_errors_for_move([0,0], [7,7], game.board, FIRST_PLAYER).should be_kind_of(String)
    end
    it "should recognize an attempt to move a piece that is not owned by current_player" do
      game.board.stub(:piece_at?).with(0,0).and_return(true)
      game.board.stub(:is_on_board?).with([7,7]).and_return(true)
      game.stub(:piece_owned_by?).with(SECOND_PLAYER, [1,1], game.board).and_return(false)
      dummy.get_errors_for_move([0,0], [7,7], game.board, SECOND_PLAYER).should be_a_kind_of(String)
    end
  end
end