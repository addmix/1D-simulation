tool
extends EditorPlugin

signal space_updated

var space_editor_panel : Control = preload("./space/SpaceEditorPanel.tscn").instance()
var space_editor_plugin : EditorSpatialGizmoPlugin = preload("./space/SimulationSpaceEditorPlugin.gd").new()
var current_gizmo
var editor_selection

func _enter_tree() -> void:
	space_editor_plugin.editor_plugin = self
	add_spatial_gizmo_plugin(space_editor_plugin)
	
	editor_selection = get_editor_interface().get_selection()
	editor_selection.connect("selection_changed", self, "on_selection_changed")
	
	space_editor_panel.connect("create_linear", self, "on_create_linear")
	space_editor_panel.connect("create_radial", self, "on_create_radial")
	
#	connect("space_updated", self, "on_space_updated")
	connect("space_updated", space_editor_plugin, "on_space_updated")

func _exit_tree() -> void:
	pass

func on_selection_changed() -> void:
	var selected = editor_selection.get_selected_nodes()
	
	#if no selection
	if selected.empty():
		return
	
	if selected[0] is SimulationSpace:
		show_space_editor()
		space_editor_plugin.set_selection(selected[0])
	else:
		hide_space_editor()
		space_editor_plugin.set_selection(null)

func show_space_editor() -> void:
	#prevents from adding when there is already a parent
	if !space_editor_panel.get_parent():
		add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, space_editor_panel)

func hide_space_editor() -> void:
	#prevents from removing if it doesnt have a parent
	if space_editor_panel.get_parent():
		remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, space_editor_panel)

func on_create_linear() -> void:
	var selected = editor_selection.get_selected_nodes()
	#if no selection
	if selected.empty():
		return
	
	if !selected[0] is SimulationSpace:
		return
	
	var segment = SimulationLinearSpace.new()
	segment.space = selected[0]
	selected[0].segments.append(segment)
	segment.init(selected[0].segments.size() - 1)
	
	emit_signal("space_updated")

func on_create_radial() -> void:
	var selected = editor_selection.get_selected_nodes()
	
	#if no selection
	if selected.empty():
		return
	
	if !selected[0] is SimulationSpace:
		return
	
	var segment = SimulationRadialSpace.new()
	segment.space = selected[0]
	selected[0].segments.append(segment)
	segment.init(selected[0].segments.size() - 1)
	
	
	emit_signal("space_updated")
