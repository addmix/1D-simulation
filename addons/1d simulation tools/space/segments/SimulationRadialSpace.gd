extends SimulationSpaceSegment
class_name SimulationRadialSpace

var resolution : float = 10.0

export var length : float = 1.0 setget set_length
func set_length(i : float) -> void:
	length = i
	arc_angle = 180.0 * length / (PI * radius)
export var radius : float = 1.0 setget set_radius
func set_radius(r : float) -> void:
	radius = r
	length = 2.0 * PI * radius * (arc_angle / 360.0)
export var arc_angle : float = 57.2958 setget set_angle
func set_angle(t : float) -> void:
	arc_angle = t
	length = 2.0 * PI * radius * (arc_angle / 360.0)

func _init(r : float = 1.0, t : float = 180.0) -> void:
	set_angle(t)
	set_radius(r)

func get_transform(i : float = 0.0) -> Transform:
	var t := transform
	t.origin += t.basis.y * radius
	t.basis = t.basis.rotated(Vector3(0, 0, 1), deg2rad(arc_angle) * i)
	t.origin -= t.basis.y * radius
	
	return global_transform * t.inverse()
	

func get_end_transform() -> Transform:
	var t := transform
	t.origin += t.basis.y * radius
	t.basis = t.basis.rotated(Vector3(0, 0, 1), deg2rad(arc_angle))
	t.origin -= t.basis.y * radius
	
	return global_transform * t.inverse()

func get_points() -> PoolVector3Array:
	var points := PoolVector3Array()
	points.append(global_transform.origin)
	for i in int(arc_angle / resolution):
		points.append(get_transform(float(i) / int(arc_angle / resolution)).origin)
		points.append(get_transform(float(i) / int(arc_angle / resolution)).origin)
	points.append(get_end_transform().origin)
#	points.remove(0)
#	points.remove(points.size() - 1)
	
	return points
