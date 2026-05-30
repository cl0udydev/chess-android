extends TextureRect

"""
Created by cl0udydev
Read it like this: first comes the comment, then what it describes
The comments were created using a translator, so I apologize for any inaccuracies.
"""

"""
This script acts as a micro-View component for an individual chess piece.
It inherits from TextureRect and is responsible solely for dynamically 
loading and displaying the correct pixel-art sprite based on the piece's type and color.
"""

# dictionary mapping numerical color enum values (0: WHITE, 1: BLACK) to their corresponding string names used in file paths.
const COLOR_MAP = {
	0: "white",
	1: "black"
}

# dictionary mapping numerical type enum values to their corresponding lowercase string names used in file paths.
const TYPE_MAP = {
	0: "pawn",
	1: "knight",
	2: "bishop",
	3: "rook",
	4: "queen",
	5: "king"
}

# configures the visual appearance of the piece. It translates numerical constants into a file path, loads the texture resource from disk, and applies it to the node's texture property.
func set_piece(type: int, color: int) -> void:
	# translates numerical enum parameters into readable string identifiers using the local mapping dictionaries.
	var color_str = COLOR_MAP[color]
	var type_str = TYPE_MAP[type]
	# dynamically constructs the absolute path to the targeted texture file within the project directory.
	var sprite_path = "res://assets/sprites/chess_pieces/" + color_str + "_" + type_str + ".png"
	# loads the image resource into memory and updates the built-in 'texture' property of the TextureRect node to render the sprite.
	texture = load(sprite_path)

func _ready() -> void:
	pass
