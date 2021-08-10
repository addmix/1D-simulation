tool
extends EditorSpatialGizmoPlugin

var editor_plugin : EditorPlugin

var selection
var cached_gizmo

func get_name() -> String:
	return "SimulationSpace"

func set_selection(path) -> void:
	selection = path

func has_gizmo(spatial) -> bool:
	return spatial is SimulationSpace

func _init() -> void:
	create_material("Path", Color(.2, .2, 1.0))

func redraw(gizmo: EditorSpatialGizmo) -> void:
	if !gizmo:
		return
	
	gizmo.clear()
	var path = gizmo.get_spatial_node()
	
	if !path:
		#no selection
		return
	
	if !selection or path != selection:
		draw_space(gizmo)
		return
	
	cached_gizmo = gizmo
	
	draw_space(gizmo)

func draw_space(gizmo : EditorSpatialGizmo) -> void:
	var space = gizmo.get_spatial_node()
	var polygon = PoolVector3Array()
	
	for segment in space.segments:
		var points : PoolVector3Array = segment.get_points()
		polygon.append_array(points)
	
	gizmo.add_lines(polygon, get_material("Path", gizmo))

func on_space_updated() -> void:
	redraw(cached_gizmo)
