extends Sprite2D

var dir := Vector2.ZERO
var speed: float = 0.0
var last_pos := position


func _ready():
	HyperLog.log(self).offset(Vector2(20.0, 20.0))
	HyperLog.log(self).text("speed>%0.1f")
	HyperLog.log(self).graph("speed")
	HyperLog.log(self).graph("last_pos")
	HyperLog.log(self).text("global_position>%0.1f")
	HyperLog.log(self).angle("dir")
	HyperLog.graph("speed", self, 0, 40).set_steps(3)


func _physics_process(delta: float) -> void:
	_update_pos(get_global_mouse_position(), delta)


func _update_pos(_new_pos:Vector2, delta: float) -> void:
	HyperLog.sketch_arrow(global_position, dir * 20.0, 1)
	HyperLog.sketch_line(global_position, global_position + (dir * (50.0 + speed * 10.0)), 0.1, Color.CORNFLOWER_BLUE)
	dir = last_pos.direction_to(_new_pos)
	var old_pos = global_position
	global_position = lerp(global_position, _new_pos, delta*4.0)
	speed = (old_pos - global_position).length()
	rotation = dir.angle() + PI / 2
	last_pos = global_position
