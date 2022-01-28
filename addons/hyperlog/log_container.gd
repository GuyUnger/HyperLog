extends PanelContainer
class_name LogContainer

var parent_node

onready var container = $container
onready var name_label = $container/name

var tracking := true
var _offset := Vector2()
var align_horizontal := 0
var align_vertical := 0

func _process(delta):
	if parent_node and parent_node != get_tree().get_root():
#		rect_global_position = parent_node.global_position
		rect_position = parent_node.get_global_transform_with_canvas().origin + _offset
		if align_horizontal == HALIGN_CENTER:
			rect_position.x -= rect_size.x / 2 * rect_scale.x
		elif align_horizontal == HALIGN_RIGHT:
			rect_position.x -= rect_size.x * rect_scale.x
		if align_vertical == VALIGN_CENTER:
			rect_position.y -= rect_size.y / 2 * rect_scale.y
		elif align_vertical == VALIGN_BOTTOM:
			rect_position.y -= rect_size.y * rect_scale.y
	
	if print_dirty:
		process_print()

func _set_name(value):
	name_label.visible = true
	name_label.text = value

#func set_size(value:float = 1)->LogContainer:
#	rect_scale = Vector2.ONE * value
#	return self

# print
onready var prints_label = $container/prints
var print_dirty := false

var print_lines := []
var print_scroll := 0
var print_lines_visible_max := 8

func print(arg1, arg2 = null, arg3 = null, arg4 = null):
	prints_label.visible = true
	var line = format(arg1)
	if arg2 != null: line += ", " + format(arg2)
	if arg3 != null: line += ", " + format(arg3)
	if arg4 != null: line += ", " + format(arg4)
	print_lines.push_back(line)
	print_dirty = true

func format(value)->String:
	if value is Color:
		var hex = value.to_html(true)
		return "[color=#" + hex + "]"+hex+"[/color]"
	elif value is bool:
		return "[color=" + ("green" if value else "red") + "]"+str(value)+"[/color]"
	return str(value)

func process_print():
	prints_label.bbcode_text = ""
	for i in min(print_lines.size(), print_lines_visible_max):
		prints_label.bbcode_text = print_lines[print_lines.size() - i - 1] + "\n" + prints_label.bbcode_text

# text
onready var ref_text = preload("res://addons/hyperlog/trackers/tracker_text.tscn")
func add_text():
	return _create_tracker(ref_text)

func text(properties, node = null):
	var tracker = add_text()
	tracker.track(properties, node)
	return tracker

# angle
onready var ref_angle = preload("res://addons/hyperlog/trackers/tracker_angle.tscn")
func add_angle():
	var tracker = _create_tracker(ref_angle)
	return tracker

func angle(properties = "rotation", node = null):
	var tracker = add_angle()
	tracker.track(properties, node)
	return tracker

# graph
onready var ref_graph = preload("res://addons/hyperlog/trackers/tracker_graph.tscn")
func add_graph():
	var tracker = _create_tracker(ref_graph)
	return tracker

func graph(properties, node = null, range_min = null, range_max = null)->TrackerGraph:
	var tracker = add_graph()
	if range_min != null:
		tracker.set_range_min(range_min)
	if range_max != null:
		tracker.set_range_max(range_max)
	tracker.track(properties, node)
	return tracker

# bar
onready var ref_bar = preload("res://addons/hyperlog/trackers/tracker_bar.tscn")
func add_bar():
	var tracker = _create_tracker(ref_bar)
	return tracker

func bar(properties, range_min:float = 0, range_max:float = 10, node = null)->TrackerGraph:
	var tracker = add_bar()
	tracker.set_range(range_min, range_max)
	tracker.track(properties, node)
	return tracker

# color
onready var ref_color = preload("res://addons/hyperlog/trackers/tracker_color.tscn")
func add_color():
	var tracker = _create_tracker(ref_color)
	return tracker

func color(properties = "modulate", node = null):
	var tracker = add_color()
	tracker.track(properties, node)
	return tracker

func _create_tracker(ref):
	var tracker = ref.instance()
	container.add_child(tracker)
	tracker.container = self
	
	return tracker

func set_width(value)->LogContainer:
	rect_size.x = value
	return self

func offset(value:Vector2)->LogContainer:
	_offset = value
	return self

func align(horizontal = HALIGN_LEFT, vertical = VALIGN_TOP)->LogContainer:
	align_horizontal = horizontal
	align_vertical = vertical
	return self

func remove():
	HyperLog.remove_log(parent_node)

#func show()->LogContainer:
#	visible = true
#	return self
#
#func hide()->LogContainer:
#	visible = false
#	return self

func hide_name()->LogContainer:
	name_label.visible = false
	return self

func show_name()->LogContainer:
	name_label.visible = true
	return self
