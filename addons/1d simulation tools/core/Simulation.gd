extends Node
class_name Simulator

export var fps := 120
onready var fps_time : float = 1.0 / float(fps)
onready var fps_time_usec : int = int(fps_time * 1000000.0)

#used for delta
var pre_time := 0.0
onready var time : int

onready var thread : Thread = Thread.new()
var stop = false

#input : hint
var input_hints := {}

var spaces := []

func _ready() -> void:
	var children : Array = get_children()
	for child in children:
		if child.get_type() == "SimulationSpace":
			spaces.append(child)
	
	var _err = thread.start(self, "run", null, Thread.PRIORITY_HIGH)

func run(_args) -> void:
	time = OS.get_ticks_usec()
	while(!stop):
		pre_time = OS.get_ticks_usec()
		
		#we can implement delta correction here
		#renormalizes to seconds
		var delta : float = (pre_time - time + fps_time_usec) / 1000000.0
		#this gives us our fps
		OS.delay_usec(fps_time_usec)
		
		_pre_step()
		_step(delta)
		_post_step()
		
		time = OS.get_ticks_usec()
	

func _pre_step() -> void:
	for space in spaces:
		space._pre_step()

func _step(delta: float) -> void:
	for space in spaces:
		space._step(delta)
	
	for space in spaces:
		space._solve_constraints(delta)

func _post_step() -> void:
	for space in spaces:
		space._post_step()

func _exit_tree() -> void:
	if thread.is_active():
		stop = true
		thread.wait_to_finish()
	
	spaces = []
