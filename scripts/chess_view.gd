extends Control

@onready var chess_board: Node = $chess_board
@onready var grid_container: GridContainer = $AspectRatioContainer/GridContainer
@onready var piece_template = preload("res://scenes/chess_piece_view.tscn")

func _on_piece_spawned(type: int, color: int, row: int, col: int) -> void:
	var flat_index = (row * 8) + col
	var target_cell = grid_container.get_child(flat_index)
	var new_piece = piece_template.instantiate()
	new_piece.set_piece(type, color)
	target_cell.add_child(new_piece)

func _ready() -> void:
	for row in range(8):
		for col in range(8):
			var cell = TextureRect.new()
			cell.custom_minimum_size = Vector2(40, 40)
			if (row + col) % 2 == 0:
				cell.texture = load("res://assets/sprites/board_cells/light_cell.png")
			else:
				cell.texture = load("res://assets/sprites/board_cells/dark_cell.png")
			grid_container.add_child(cell)
	chess_board.piece_spawned.connect(_on_piece_spawned)
	chess_board.setup_initial_board()
