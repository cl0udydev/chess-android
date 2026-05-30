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
It manages player interaction via touch inputs and handles the visual state of piece selection and movement.
"""

# reference to the logical chess board node (Model) that handles game state and piece spawning.
@onready var chess_board: Node = $chess_board

# reference to the GridContainer node that automatically arranges 64 board cells into an 8x8 layout.
@onready var grid_container: GridContainer = $AspectRatioContainer/GridContainer

# preloads the scene template for a visual chess piece, allowing the script to instantly instantiate sprites in memory.
@onready var piece_template = preload("res://scenes/chess_piece_view.tscn")

# stores the coordinates of the currently active/selected board cell using a 2D integer vector (col, row). Defaults to (-1, -1), indicating that no cell is selected.
var selected_cell: Vector2i = Vector2i(-1, -1)

# callback method that triggers when the logical board emits the 'piece_moved' signal. It cleans up the old cell by freeing its child sprite, clears the target cell to handle potential captures, and re-renders the moved piece at its new logical position.
func _on_piece_moved(from_row: int, from_col: int, to_row: int, to_col: int) -> void:
	var from_flat = (from_row * 8) + from_col
	var from_cell = grid_container.get_child(from_flat)
	# safely destroys the visual piece instance at the old location to clear the cell.
	for child in from_cell.get_children():
		child.queue_free()
	var to_flat = (to_row * 8) + to_col
	var to_cell = grid_container.get_child(to_flat)
	# safely destroys any pre-existing piece at the destination cell (handling chess captures).
	for child in to_cell.get_children():
		child.queue_free()
	# fetches the updated data from the Model to re-draw the piece at its new destination.
	var piece_data = chess_board.get_piece_at(to_row, to_col)
	if piece_data != null:
		_on_piece_spawned(piece_data.type, piece_data.color, to_row, to_col)

# callback method that triggers when the logical board emits the 'piece_spawned' signal. It calculates the flat grid index, finds the corresponding cell, instantiates a new visual piece, and attaches it as a child of that cell.
func _on_piece_spawned(type: int, color: int, row: int, col: int) -> void:
	var flat_index = (row * 8) + col
	var target_cell = grid_container.get_child(flat_index)
	var new_piece = piece_template.instantiate()
	new_piece.set_piece(type, color)
	target_cell.add_child(new_piece)

# handles mouse clicks and touch screen press events for individual board cells. Implements a 2-state input machine: state 1 selects a valid piece, state 2 executes a move to the target coordinates and resets selection.
func _on_cell_input(event: InputEvent, row: int, col: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			# state 1: No piece is currently selected. Attempting to select a piece at the tapped coordinates.
			if selected_cell == Vector2i(-1, -1):
				var piece = chess_board.get_piece_at(row, col)
				if piece != null:
					selected_cell = Vector2i(col, row)
					print("фигура выбрана на: ", selected_cell)
			# state 2: A piece was previously selected. Treating the current tap as the destination for a move.
			else:
				var from_row = selected_cell.y
				var from_col = selected_cell.x
				print("пытаемся совершить ход из ", from_row, ", ", from_col, " в ", row, ", ", col)
				# requests the Model to validate the move configuration before triggering physical displacement.
				if chess_board.is_move_valid(from_row, from_col, row, col):
					# Calls down to the Model to execute the logical transformation.
					chess_board.move_piece(from_row, from_col, row, col)
				# Resets the state machine back to selection mode.
				selected_cell = Vector2i(-1, -1)

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
			# connects the GUI input signal of each generated cell to the interaction handler, binding its strict logical row and column.
			cell.gui_input.connect(_on_cell_input.bind(row, col))
	# connects to the Model's signals to listen for dynamically spawned and moved pieces.
	chess_board.piece_spawned.connect(_on_piece_spawned)
	chess_board.piece_moved.connect(_on_piece_moved)
	# signals the Model to start calculation and placement of the initial 32 pieces.
	chess_board.setup_initial_board()
