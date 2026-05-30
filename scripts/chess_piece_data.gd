extends Resource

class_name ChessPieceData

"""
Created by cl0udydev
Read it like this: first comes the comment, then what it describes
The comments were created using a translator, so I apologize for any inaccuracies.
"""

"""
This script defines the data structure for a single chess piece.
It serves as a clean, lightweight object that stores properties without any visual logic.
"""

# enumeration for piece colors. In Godot, these are mapped to integers under the hood: WHITE = 0, BLACK = 1.
enum PieceColor { WHITE, BLACK }

# enumeration for piece types. Mapped to integers: PAWN = 0, KNIGHT = 1, BISHOP = 2, ROOK = 3, QUEEN = 4, KING = 5.
enum PieceType { PAWN, KNIGHT, BISHOP, ROOK, QUEEN, KING }

# exposes the piece's color to the Inspector and enforces static typing using the PieceColor enum. Default is WHITE.
@export var color: PieceColor = PieceColor.WHITE

# exposes the piece's type to the Inspector and enforces static typing using the PieceType enum. Default is PAWN.
@export var type: PieceType = PieceType.PAWN

# validates the purely geometric capabilities of a piece based on its type. It calculates absolute coordinate deltas, unsigned vertical offsets, and employs a structural match statement to enforce distinct movement vectors for kings, rooks, pawns, knights, bishops, and queens.
func is_geometry_valid(from_row: int, from_col: int, to_row: int, to_col: int) -> bool:
	var dr = abs(to_row - from_row)
	var dc = abs(to_col - from_col)
	var row_dir = to_row - from_row
	match type:
		# king: moves exactly 1 square in any direction (horizontal, vertical, or diagonal).
		PieceType.KING:
			return dr <= 1 and dc <= 1
		# rook: moves any number of squares along straight horizontal or vertical lines.
		PieceType.ROOK:
			return (dr > 0 and dc == 0) or (dr == 0 and dc > 0)
		# pawn: moves forward by 1 square, or optionally by 2 squares if starting from its initial row rank.
		PieceType.PAWN:
			if color == PieceColor.WHITE:
				var normal_move = (row_dir == -1 and dc == 0)
				var double_move = (row_dir == -2 and dc == 0 and from_row == 6)
				return normal_move or double_move
				
			else:
				var normal_move = (row_dir == 1 and dc == 0)
				var double_move = (row_dir == 2 and dc == 0 and from_row == 1)
				return normal_move or double_move
		# knight: leaps in an l-shape vector consisting of 2 squares on one axis and 1 square on the other.
		PieceType.KNIGHT:
			return (dr == 2 and dc == 1) or (dr == 1 and dc == 2)
		# bishop: slides diagonally across any number of squares where row and column deltas are perfectly equal.
		PieceType.BISHOP:
			return dr == dc
		# queen: omnidirectional powerhouse that combines the linear movement of a rook and the diagonal movement of a bishop.
		PieceType.QUEEN:
			return (dr > 0 and dc == 0) or (dr == 0 and dc > 0) or (dr == dc)
		# default: catch-all fallback branch to ensure safe return values for unregistered types.
		_:
			return true
