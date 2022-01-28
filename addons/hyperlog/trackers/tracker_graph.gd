extends Tracker
class_name TrackerGraph

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

func _init():
	set_height(80)

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
		update()
		_dirty = false

func _draw():
	next_min_value = 999999.0
	next_max_value = -999999.0
	var next_tracking_length = 1
	
	
	if min_value < 0 and max_value > 0:
		var zero_height = _range_value(0)
		draw_line(Vector2(0, zero_height), Vector2(rect_size.x, zero_height), Color(.8, .8, .8, .4))
	
	draw_line(Vector2(0, 1), Vector2(rect_size.x, 1), Color(1, 1, 1, .5))
	draw_line(Vector2(0, rect_size.y-1), Vector2(rect_size.x, rect_size.y-1), Color(1, 1, 1, .5))
	
	var color_index := 0
	for tracker in trackers:
		next_tracking_length = max(next_tracking_length, tracker.backlog.size())
		
		if tracker.backlog.size() < 2: continue
		
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
	if force_max_value == null:
		max_value = next_max_value
	tracking_length = next_tracking_length
	
	if min_value == max_value:
		max_value += .00001

func _graph_segment(from, to, pos, color_index):
		next_min_value = min(next_min_value, from)
		next_max_value = max(next_max_value, from)
		
		var pos_from = Vector2(
				pos / float(tracking_length) * rect_size.x,
				_range_value(from)
			)
		
		var pos_to = Vector2(
				(pos + 1) / float(tracking_length) * rect_size.x,
				_range_value(to)
			)
		
		draw_line(pos_from, pos_to, HyperLog.colors[color_index])

func _range_value(value)->float:
	return (1 - ( (value - min_value) / (max_value - min_value) ) ) * (rect_min_size.y - 2) + 1

func set_range_min(value:float)->Tracker:
	force_min_value = value
	min_value = value
	return self

func set_range_max(value:float)->Tracker:
	force_max_value = value
	max_value = value
	return self

func set_range(value_min:float, value_max:float)->Tracker:
	force_min_value = value_min
	min_value = value_min
	force_max_value = value_max
	max_value = value_max
	return self

func set_steps(value:int)->TrackerGraph:
	step_size = value
	return self
