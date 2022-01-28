extends Node

var main_log:LogContainer

var colors := []

onready var canvas = $canvas 
onready var sketchboard = $canvas/sketchboard 

var containers := []

func _ready():
	main_log = $main_log
	main_log.hide()
	main_log.parent_node = get_tree().root
	
	for i in 64:
		var color = Color.red
		color.h += i * (1 / 4.0 + 1 / 32.0)
		color.v *= 1 - (i / 128.0) * .5
		colors.push_back(color)

onready var container_ref = preload("res://addons/hyperlog/log_container.tscn")
func log(node:Node, print1 = null, print2 = null, print3 = null, print4 = null)->LogContainer:
	var container = get_container(node)
	if print1 != null:
		container.print(print1, print2, print3, print4)
	container.set_scale(Vector2.ONE * .75)
	return container

func remove_log(node:Node):
	for i in containers.size():
		if containers[i].parent_node == node:
			containers[i].queue_free()
			containers.remove(i)
			return

func pause_log(node:Node):
	for container in containers:
		if container.parent_node == node:
			container.tracking = false
			return

func continue_log(node:Node):
	for container in containers:
		if container.parent_node == node:
			container.tracking = true
			return

func get_container(node):
	for container in containers:
		if container.parent_node == node:
			return container
	
	var container = container_ref.instance()
	add_child(container)
	container.parent_node = node
	container._set_name(node.name)
	containers.push_back(container)
	return container

func print(arg1, arg2 = null, arg3 = null, arg4 = null):
	main_log.print(arg1, arg2, arg3, arg4)

# LOG
func add_text()->TrackerText:
	main_log.show()
	return main_log.add_text()

func text(properties, node = null)->TrackerText:
	main_log.show()
	return main_log.text(properties, node)

func add_angle()->TrackerAngle:
	main_log.show()
	return main_log.add_angle()

func angle(properties = "rotation", node = null)->TrackerAngle:
	main_log.s1ow()
	return main_log.angle(properties, node)

func add_graph()->TrackerGraph:
	main_log.show()
	return main_log.add_graph()

func graph(properties, node = null, range_min = null, range_max = null)->TrackerGraph:
	main_log.show()
	return main_log.graph(properties, node, range_min, range_max)

func add_color()->TrackerColor:
	main_log.show()
	return main_log.add_color()

func color(properties = "modulate", node = null)->TrackerColor:
	main_log.show()
	return main_log.color(properties, node)

# SKETCH

func sketch_line(from:Vector2, to:Vector2, duration:float = 0, color:Color = Color.tomato):
	sketchboard.lines.push_back([from, to, color, duration * 1000, OS.get_ticks_msec()])

func sketch_arrow(position:Vector2, vector:Vector2, duration:float = 0, color:Color = Color.tomato):
	sketchboard.arrows.push_back([position, position + vector, color, duration * 1000, OS.get_ticks_msec()])

func sketch_circle(position:Vector2, radius:float, duration:float = 0, color:Color = Color.tomato):
	sketchboard.circles.push_back([position, radius, color, duration * 1000, OS.get_ticks_msec()])

func sketch_box(position:Vector2, size:Vector2, duration:float = 0, color:Color = Color.tomato):
	sketch_rect(Rect2(position - size / 2.0, size), duration, color)

func sketch_rect(rect:Rect2, duration:float = 0, color:Color = Color.tomato):
	sketchboard.rects.push_back([rect, color, duration * 1000, OS.get_ticks_msec()])
