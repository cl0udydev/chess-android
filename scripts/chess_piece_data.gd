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
