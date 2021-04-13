extends CSGBox

func _process(_delta : float) -> void:
	transform.origin.x = get_parent().position
