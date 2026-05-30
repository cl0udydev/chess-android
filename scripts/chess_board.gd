extends Node

"""
Created by cl0udydev
Read it like this: first comes the comment, then what it describes
The comments were created using a translator, so I apologize for any inaccuracies.
"""

"""
this script plays the role of the Model in the MVC architectural pattern. 
It is isolated from the game's visual interface, knows nothing about sprites or pixels, 
and serves as the sole source of truth for the state of the chess game.
"""

# a two-dimensional array (8x8 matrix) representing the coordinate grid of the game board. The cells can contain: A custom ChessPieceData object (if the cell contains a piece). A null value (if the cell is empty).
var board: Array

# global alert signal. Sent every time a new piece is materialized on the logic board. Allows the visual representation layer (ChessView) to synchronize the image on the smartphone screen without direct connection to the logic.
signal piece_spawned(type: int, color: int, row: int, col: int)

# global alert signal. Sent every time a piece is shifted from one grid cell to another. Allows the view layer to update and clear corresponding visual nodes.
signal piece_moved(from_row: int, from_col: int, to_row: int, to_col: int)

# chief referee method. It screens out identity moves, absent source data, friendly fire, and evaluates combined structural geometric patterns to determine basic movement legality for any selected piece.
func is_move_valid(from_row: int, from_col: int, to_row: int, to_col: int) -> bool:
	if from_row == to_row and from_col == to_col:
		return false
	var piece = get_piece_at(from_row, from_col)
	if piece == null:
		return false
	var target_piece = get_piece_at(to_row, to_col)
	if target_piece != null and target_piece.color == piece.color:
		return false
	
	return piece.is_geometry_valid(from_row, from_col, to_row, to_col)


# processes the logical displacement of a piece inside the matrix. It extracts the resource data, frees the initial cell, re-assigns the target cell, and fires the movement signal.
func move_piece(from_row: int, from_col: int, to_row: int, to_col: int) -> void:
	var piece_to_move = board[from_row][from_col]
	board[from_row][from_col] = null
	board[to_row][to_col] = piece_to_move
	piece_moved.emit(from_row, from_col, to_row, to_col)

# using nested loops, it creates an 8x8 matrix, filling each cell with a null value. This ensures that the game session starts with a clean coordinate grid.
func create_chess_board() -> void:
	for y in range(8):
		var current_row: Array
		for x in range(8):
			current_row.append(null)
		board.append(current_row)

# a factory method for dynamically generating a shape.
func spawn_piece(type: int, color: int, row: int, col: int) -> void:
	# initializes a new unique instance of the data class using ChessPieceData.new()
	var new_piece = ChessPieceData.new()
	# writes the passed numeric parameters type and color (from the enum enumerations) to the internal properties of the created resource.
	new_piece.color = color
	new_piece.type = type
	# places a reference to the object in the board matrix at the target coordinates. Transmits the piece_spawned.emit() signal to the outside world with the metadata of the created piece.
	board[row][col] = new_piece
	piece_spawned.emit(type, color, row, col)

# the initial arrangement of 32 pieces according to the rules of classical chess.
func setup_initial_board() -> void:
	# pawn line: The for x in range(8) loop fills the sixth row (row = 6) with white pawns and the first row (row = 1) with black pawns.
	for x in range(8):
		spawn_piece(ChessPieceData.PieceType.PAWN, ChessPieceData.PieceColor.WHITE, 6, x)
		spawn_piece(ChessPieceData.PieceType.PAWN, ChessPieceData.PieceColor.BLACK, 1, x)
	# heavy pieces: Using a compact for i in range(2) loop, it iterates over the sides (the index i corresponds to the color of the enum). The ternary operator 7 if i == 0 else 0 automatically assigns white pieces (i = 0) to the seventh row and black pieces (i = 1) to the zero row, rigidly fixing the order of piece types in columns 0 to 7.
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

# it sequentially starts building an empty board matrix (create_chess_board) and then fills it with starting pieces using the factory (setup_initial_board).
func _ready() -> void:
	create_chess_board()
	setup_initial_board()
	
# getter method that safely retrieves the logical piece data at the specified coordinates. Returns a ChessPieceData object if a piece exists, or null if the cell is empty. Enforces strict bounds checking implicitly via array indices.
func get_piece_at(row: int, col: int) -> Variant:
	return board[row][col]
