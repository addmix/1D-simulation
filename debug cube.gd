tool
extends CSGBox
class_name DebugViewer

export var _height : float = 1.0
export var _depth : float = 1.0

func _ready() -> void:
	height = _height
	depth = _depth

func get_type() -> String:
	return ""

func _process(_delta : float) -> void:
	transform.origin.x = get_parent().position
