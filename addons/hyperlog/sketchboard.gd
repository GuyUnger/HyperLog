class_name Sketchboard extends Node2D

var lines := []
var circles := []
var arrows := []
var rects := []


func _process(delta):
	queue_redraw()


func _draw():
	var time = Time.get_ticks_msec()
	
	var i:int
	
	# LINES
	i = 0
	while i < lines.size():
		var data = lines[i]
		var duration = data[3]
		var color = data[2]
		var from = data[0]
		var to = data[1]
		if duration == 0:
			lines.remove_at(i)
		else:
			var start = data[4]
			color.a *= get_alpha(start, duration, time)
			if start + duration < time:
				lines.remove_at(i)
			else:
				i += 1
		draw_line(from, to, color, 1.0, true)
	
	# ARROWS
	i = 0
	while i < arrows.size():
		var data = arrows[i]
		var duration = data[3]
		var color = data[2]
		var from = data[0]
		var to = data[1]
		
		if duration == 0:
				arrows.remove_at(i)
		else:
			var start = data[4]
			color.a *= get_alpha(start, duration, time)
			if start + duration < time:
				arrows.remove_at(i)
			else:
				i += 1
		
		if from == to:
			draw_circle(from, 2, color)
		else:
			draw_line(from, to, color, 1.0, true)
			var angle = from.angle_to_point(to) + PI
			draw_line(to, to + Vector2.RIGHT.rotated(angle - 0.4) * 16, color, 1.0, true)
			draw_line(to, to + Vector2.RIGHT.rotated(angle + 0.4) * 16, color, 1.0, true)
	
	# CIRCLES
	i = 0
	while i < circles.size():
		var data = circles[i]
		var duration = data[3]
		var color = data[2]
		var position = data[0]
		var radius = data[1]
		if duration == 0:
			circles.remove_at(i)
		else:
			var start = data[4]
			color.a *= get_alpha(start, duration, time)
			if start + duration < time:
				circles.remove_at(i)
			else:
				i += 1
		
		var prev_point
		for j in 13:
			var point = Vector2.RIGHT.rotated(j / 12.0 * TAU) * radius + position
			if prev_point:
				draw_line(prev_point, point, color, 1.0, true)
			prev_point = point
#		draw_circle(data[0], data[1], color)
	
	# RECTS
	i = 0
	while i < rects.size():
		var data = rects[i]
		var duration = data[2]
		var color = data[1]
		var rect = data[0]
		if duration == 0:
			rects.remove_at(i)
		else:
			var start = data[3]
			color.a *= get_alpha(start, duration, time)
			if start + duration < time:
				rects.remove_at(i)
			else:
				i += 1
		draw_rect(data[0], color, false)


func get_alpha(start:float, duration:float, current:float):
	return 1.0 - ( (current - start) / duration) * .9
