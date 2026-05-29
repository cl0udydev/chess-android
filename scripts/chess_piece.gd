extends Resource

class_name ChessPieceData

enum PieceColor { WHITE, BLACK }
enum PieceType { PAWN, KNIGHT, BISHOP, ROOK, QUEEN, KING }

@export var color: PieceColor = PieceColor.WHITE
@export var type: PieceType = PieceType.PAWN
