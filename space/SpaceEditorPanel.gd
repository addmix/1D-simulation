tool
extends Control

signal create_linear
signal create_radial

func _on_CreateRadial_pressed():
	emit_signal("create_radial")

func _on_CreateLinear_pressed():
	emit_signal("create_linear")
