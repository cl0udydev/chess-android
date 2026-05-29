extends Node

var board: Array
signal piece_spawned(type: int, color: int, row: int, col: int)

func create_chess_board() -> void:
	for y in range(8):
		var current_row: Array
		for x in range(8):
			current_row.append(null)
		board.append(current_row)

func spawn_piece(type: int, color: int, row: int, col: int) -> void:
	var new_piece = ChessPieceData.new()
	new_piece.color = color
	new_piece.type = type 
	board[row][col] = new_piece
	piece_spawned.emit(type, color, row, col)

func setup_initial_board() -> void:
	for x in range(8):
		spawn_piece(ChessPieceData.PieceType.PAWN, ChessPieceData.PieceColor.WHITE, 6, x)
		spawn_piece(ChessPieceData.PieceType.PAWN, ChessPieceData.PieceColor.BLACK, 1, x)
	for i in range(2):
		var row = 7 if i == 0 else 0
		spawn_piece(ChessPieceData.PieceType.ROOK, i, row, 0)
		spawn_piece(ChessPieceData.PieceType.KNIGHT, i, row, 1)	
		spawn_piece(ChessPieceData.PieceType.BISHOP, i, row, 2)	
		spawn_piece(ChessPieceData.PieceType.QUEEN, i, row, 3)	
		spawn_piece(ChessPieceData.PieceType.KING, i, row, 4)
		spawn_piece(ChessPieceData.PieceType.BISHOP, i, row, 5)	
		spawn_piece(ChessPieceData.PieceType.KNIGHT, i, row, 6)	
		spawn_piece(ChessPieceData.PieceType.ROOK, i, row, 7)

func _ready() -> void:
	create_chess_board()
	setup_initial_board()
	
func _process(_delta: float) -> void:
	pass
