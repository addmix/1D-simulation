extends Object
class_name SimulationSpaceSegment

var transform : Transform = Transform()
var global_transform : Transform = Transform()

var twist := Vector3.ZERO

var space
var parent
var child : SimulationSpaceSegment

func init(pos : int) -> void:
	get_neighbors(pos)
	calculate_global_transform()

func get_neighbors(pos : int) -> void:
	if pos + 1 < space.segments.size():
		child = space.segments[pos + 1]
	if pos > 0:
		parent = space.segments[pos - 1]
	else:
		parent = space

func calculate_global_transform() -> void:
	global_transform = transform * parent.get_end_transform()

func get_transform(i : float = 0.0) -> Transform:
	return Transform()

func get_end_transform() -> Transform:
	return Transform()

func get_points() -> PoolVector3Array:
	return PoolVector3Array([global_transform.origin, get_end_transform().origin])
