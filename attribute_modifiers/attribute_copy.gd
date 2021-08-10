extends AttributeModifier
class_name AttributeCopy

func get_type() -> String:
	return("AttributeCopy")

func update_attribute_values() -> void:
	write.set(write_variable, read.get(read_variable))
