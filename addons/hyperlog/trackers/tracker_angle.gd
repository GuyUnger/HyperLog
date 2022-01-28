extends Tracker
class_name TrackerAngle

var values := []

var scroll_speed := 1.0

var steps := 20

func _init():
	set_height(80)

func add_tracker(property:String = "rotation", object:Node = null)->ValueTracker:
	return .add_tracker(property, object)

func _physics_process(delta):
	if not container.tracking: return
	trackers_store_value()

func _process(delta):
	if not container.tracking: return
	update()

func _draw():
	var radius = rect_min_size.y / 2
	var center = Vector2(radius, radius)
	for j in trackers.size():
		var tracker = trackers[j]
		for i in range(1, tracker.backlog.size() - steps - 1, steps):
			var value_a = tracker.backlog[i]
			var value_b = tracker.backlog[i + steps]
			if value_a is Vector2:
				value_a = value_a.angle()
				value_b = value_b.angle()
			var color = HyperLog.colors[j]
			color.a = (1 - i / float(tracker.max_log_length)) * .6
			
			draw_arch(
					Vector2(value_a, radius / (1.0 + (i / (350.0 / scroll_speed) ) )),
					Vector2(value_b, radius / (1.0 + ((i + steps) / (350.0 / scroll_speed)) )),
					color, center
				)
	
	for j in trackers.size():
		var tracker = trackers[j]
		if tracker.backlog.size() > 0:
			var current_angle = tracker.backlog[0]
			if current_angle is Vector2:
				current_angle = current_angle.angle()
			draw_line(center, Vector2.RIGHT.rotated(current_angle) * radius + center, HyperLog.colors[j], 2, true)
	
	draw_circle(center, radius, Color(1, 1, 1, .1))

func draw_arch(from, to, color, center):
	var step_size = .4
	var total_arch = angle_difference(from.x, to.x)
	
	if abs(total_arch) < step_size:
		draw_line(
				Vector2.RIGHT.rotated(from.x) * from.y + center,
				Vector2.RIGHT.rotated(to.x) * to.y + center,
				color)
	else:
		var current_angle = from.x
		var previous_angle = from.x
		var current_radius = from.y
		var previous_radius = from.y
		var do = true
		while do:
			if abs(angle_difference(current_angle, to.x)) < step_size:
				current_angle = to.x
				current_radius = to.y
				do = false
			else:
				current_angle = angle_towards(current_angle, to.x, step_size)
				current_radius = from.y# + .01#lerp(from.y, to.y, angle_difference(from.x, current_angle) / total_arch)
			draw_line(
						Vector2.RIGHT.rotated(current_angle) * current_radius + center,
						Vector2.RIGHT.rotated(previous_angle) * previous_radius + center,
						color)
			
			previous_angle = current_angle
			previous_radius = current_radius


func angle_difference(a:float, b:float):
	return fposmod(b-a + PI, PI * 2) - PI

func angle_towards(from:float, to:float, delta:float):
	return from + sign(angle_difference(from, to)) * delta


func set_height(value:float)->Tracker:
	rect_min_size.x = value
	return .set_height(value)


#func polarize(position):
#	Vector2.RIGHT.rotated(position.x) * radius / (position.y / (350.0 / scroll_speed) )
