class_name TrackerGraph extends Tracker

const MAX_STR := "Max: %0.1f"
const MIN_STR := "Min: %0.1f"

var min_value := 0.0
var max_value := 0.1
var tracking_length := 1

var next_min_value := 0.0
var next_max_value := 0.0

var force_min_value = null
var force_max_value = null

var step_size := 20
var _step := 0
var _dirty := false

@onready var name_label := $labels/name_label
@onready var max_label := $labels/max_value
@onready var min_label := $min_value


func _init():
	set_height(80)


func add_tracker(property:String, node:Node = null)->ValueTracker:
	if container.parent_node and node != container.parent_node:
		name_label.text = str(container.parent_node.get_path_to(node)) + " > " + property
	else:
		name_label.text = property
	return super.add_tracker(property, node)


func _physics_process(delta):
	if not container.tracking: return
	_step -= 1
	if _step < step_size:
		_step += step_size
		trackers_store_value()
		_dirty = true


func _process(delta):
	if not container.tracking: return
	if _dirty:
		queue_redraw()
		_dirty = false


func _draw():
	next_min_value = 999999.0
	next_max_value = -999999.0
	var next_tracking_length = 1
	
	if min_value < 0 and max_value > 0:
		var zero_height = _range_value(0)
		draw_line(Vector2(0, zero_height), Vector2(size.x, zero_height), Color(0.8, 0.8, 0.8, 0.4), 1.0, true)
	
	draw_line(Vector2(0.0, 1.0), Vector2(size.x, 1), Color(1.0, 1.0, 1.0, 0.5), 1.0, true)
	draw_line(Vector2(0.0, size.y - 1.0), Vector2(size.x, size.y - 1), Color(1.0, 1.0, 1.0, 0.5), 1.0, true)
	
	var color_index := 0
	for tracker in trackers:
		next_tracking_length = max(next_tracking_length, tracker.backlog.size())
		
		if tracker.backlog.size() < 2:
			continue
		
		if tracker.backlog[0] is Vector2:
			for i in range(0, tracker.backlog.size() - 1):
				_graph_segment(tracker.backlog[i].x, tracker.backlog[i + 1].x, i, color_index)
				_graph_segment(tracker.backlog[i].y, tracker.backlog[i + 1].y, i, color_index + 1)
			color_index += 2
		elif tracker.backlog[0] is Vector3:
			for i in range(0, tracker.backlog.size() - 1):
				_graph_segment(tracker.backlog[i].x, tracker.backlog[i + 1].x, i, color_index)
				_graph_segment(tracker.backlog[i].y, tracker.backlog[i + 1].y, i, color_index + 1)
				_graph_segment(tracker.backlog[i].z, tracker.backlog[i + 1].z, i, color_index + 2)
			color_index += 3
		else:
			for i in range(0, tracker.backlog.size() - 1):
				_graph_segment(tracker.backlog[i], tracker.backlog[i + 1], i, color_index)
			color_index += 1
	
	if force_min_value == null:
		min_value = next_min_value
		min_label.text = MIN_STR % min_value
	if force_max_value == null:
		max_value = next_max_value
		max_label.text = MAX_STR % max_value
	tracking_length = next_tracking_length
	
	if min_value == max_value:
		max_value += 0.00001


func _graph_segment(from, to, pos, color_index):
		next_min_value = min(next_min_value, from)
		next_max_value = max(next_max_value, from)
		
		var pos_from = Vector2(
				pos / float(tracking_length) * size.x,
				_range_value(from)
			)
		
		var pos_to = Vector2(
				(pos + 1) / float(tracking_length) * size.x,
				_range_value(to)
			)
		
		draw_line(pos_from, pos_to, HyperLog.colors[color_index], 1.0, true)


func _range_value(value)->float:
	return (1 - ( (value - min_value) / (max_value - min_value) ) ) * (custom_minimum_size.y - 2) + 1


func set_range_min(value:float)->Tracker:
	force_min_value = value
	min_value = value
	min_label.text = MIN_STR % min_value
	return self


func set_range_max(value:float)->Tracker:
	force_max_value = value
	max_value = value
	max_label.text = MAX_STR % max_value
	return self


func set_range(value_min:float, value_max:float)->Tracker:
	force_min_value = value_min
	min_value = value_min
	min_label.text = MIN_STR % min_value
	force_max_value = value_max
	max_value = value_max
	max_label.text = MAX_STR % max_value
	return self


func set_steps(value:int)->TrackerGraph:
	step_size = value
	return self
