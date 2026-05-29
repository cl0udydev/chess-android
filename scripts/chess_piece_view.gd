extends TextureRect

const COLOR_MAP = {
	0: "white",
	1: "black"
}

const TYPE_MAP = {
	0: "pawn",
	1: "knight",
	2: "bishop",
	3: "rook",
	4: "queen",
	5: "king"
}

func set_piece(type: int, color: int) -> void:
	var color_str = COLOR_MAP[color]
	var type_str = TYPE_MAP[type]
	var sprite_path = "res://assets/sprites/chess_pieces/" + color_str + "_" + type_str + ".png"
	texture = load(sprite_path)


func _ready() -> void:
	pass
	


