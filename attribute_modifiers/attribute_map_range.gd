extends AttributeModifier
class_name AttributeMapRange

export var read_min : float = 0.0 setget set_read_min
export var read_max : float = 1.0 setget set_read_max
export var write_min : float = 0.0 setget set_write_min
export var write_max : float = 1.0 setget set_write_max
export var extrapolate : bool = true

func set_read_min(value : float) -> void:
	read_min = value
	update_map()
func set_read_max(value : float) -> void:
	read_max = value
	update_map()
func set_write_min(value : float) -> void:
	write_min = value
	update_map()
func set_write_max(value : float) -> void:
	write_max = value
	update_map()

var delta_left : float = 1.0
var delta_right : float = 1.0

func update_map() -> void:
	# Figure out how 'wide' each range is
	delta_left = read_max - read_min
	delta_right = write_max - write_min

func get_type() -> String:
	return("AttributeMapRange")

func update_attribute_values() -> void:
	# Convert the left range into a 0-1 range (float)
	var scaled : float = (read.get(read_variable) - read_min) / delta_left
	# Convert the 0-1 range into a value in the right range.
	var value : float = write_min + (scaled * delta_right)
	
	#clamp scaled value whether extrapolation is enabled
	value = clamp(value, write_min, write_max) * float(!extrapolate) + value * float(extrapolate)
	
	write.set(write_variable, value)
