extends Node
class_name AttributeModifier

func get_type() -> String:
	return "AttributeModifier"

#reading values
var read : Node setget set_read, get_read
func set_read(node) -> void:
	read = node
func get_read() -> Node:
	return read

export var read_target : NodePath setget set_read_target, get_read_target
func set_read_target(path : NodePath) -> void:
	read_target = path
	set_read(read_target)
func get_read_target() -> NodePath:
	return read_target

export var read_variable : String = ""

#writing values
var write : Node setget set_write, get_write
func set_write(node) -> void:
	write = node
func get_write() -> Node:
	return write

export var write_target : NodePath setget set_write_target, get_write_target
func set_write_target(path : NodePath) -> void:
	write_target = path
	set_write(write_target)
func get_write_target() -> NodePath:
	return write_target

export var write_variable : String = ""

func _pre_step() -> void:
	_update_attribute_values()

func _update_attribute_values() -> void:
	update_attribute_values()

func update_attribute_values() -> void:
	pass
