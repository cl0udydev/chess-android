extends Control

"""
Created by cl0udydev
Read it like this: first comes the comment, then what it describes
The comments were created using a translator, so I apologize for any inaccuracies.
"""

"""
This script plays the role of the View in the MVC architectural pattern.
It listens to signals from the logical chess board and dynamically renders 
the visual board cells and chess pieces, maintaining a responsive layout for mobile screens.
"""

# reference to the logical chess board node (Model) that handles game state and piece spawning.
@onready var chess_board: Node = $chess_board

# reference to the GridContainer node that automatically arranges 64 board cells into an 8x8 layout.
@onready var grid_container: GridContainer = $AspectRatioContainer/GridContainer

# preloads the scene template for a visual chess piece, allowing the script to instantly instantiate sprites in memory.
@onready var piece_template = preload("res://scenes/chess_piece_view.tscn")

# callback method that triggers when the logical board emits the 'piece_spawned' signal. It calculates the flat grid index, finds the corresponding cell, instantiates a new visual piece, and attaches it as a child of that cell.
func _on_piece_spawned(type: int, color: int, row: int, col: int) -> void:
	var flat_index = (row * 8) + col
	var target_cell = grid_container.get_child(flat_index)
	var new_piece = piece_template.instantiate()
	new_piece.set_piece(type, color)
	target_cell.add_child(new_piece)

# initialization method. It generates a checkered 8x8 layout using TextureRect nodes, populates the GridContainer, connects the piece spawning signal, and triggers the initial logical board arrangement.
func _ready() -> void:
	# nested loops iterate through rows and columns to generate 64 distinct cells.
	for row in range(8):
		for col in range(8):
			var cell = TextureRect.new()
			# enforces a minimum cell size to prevent the grid from collapsing on mobile displays.
			cell.custom_minimum_size = Vector2(40, 40)
			# applies a classic chess checkered pattern condition based on coordinate parity.
			if (row + col) % 2 == 0:
				cell.texture = load("res://assets/sprites/board_cells/light_cell.png")
			else:
				cell.texture = load("res://assets/sprites/board_cells/dark_cell.png")
			# appends the fully configured texture cell into the flat array of the GridContainer.
			grid_container.add_child(cell)
	# connects to the Model's signal to listen for dynamically spawned pieces.
	chess_board.piece_spawned.connect(_on_piece_spawned)
	# sSignals the Model to start calculation and placement of the initial 32 pieces.
	chess_board.setup_initial_board()