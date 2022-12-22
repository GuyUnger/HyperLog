extends Node3D

var dir := Vector2.ZERO
var speed := 0.0
var mouse_pos := Vector2.ZERO
var last_pos := Vector2.ZERO
var target_rotation := Vector2.ZERO

@onready var mouse_tracker := $MouseTracker
@onready var container := $Container


func _enter_tree() -> void:
	# This needs to be set first, it can also be done from the camera when changing in-game cams.
	HyperLog.camera_3d = $Camera3D


func _ready() -> void:
	HyperLog.text("speed>%0.1f", self)
	HyperLog.text("dir>%0.1f", self)
	HyperLog.log($Ball).offset(Vector2(20,20))
	HyperLog.log($Ball).text("global_position>%0.1f")
	HyperLog.log($Ball).text("linear_velocity>%0.1f")
	HyperLog.log($Ball2).offset(Vector2(20,20))
	HyperLog.log($Ball2).text("global_position>%0.1f")
	HyperLog.log($Ball2).text("linear_velocity>%0.1f")


func _physics_process(delta:float) -> void:
	_update_pos(mouse_tracker.get_global_mouse_position(), delta)
	target_rotation.x = lerp(target_rotation.x, clamp(target_rotation.x + (-dir.normalized().x*speed*0.01), -0.2, 0.2), delta*10)
	target_rotation.y = lerp(target_rotation.y, clamp(target_rotation.y + (dir.normalized().y*speed*0.01), -0.2, 0.2), delta*10)
	container.rotation.z = target_rotation.x
	container.rotation.x = target_rotation.y


func _update_pos(_new_pos:Vector2, delta:float) -> void:
	HyperLog.sketch_arrow(mouse_pos, dir, 1)
	dir = last_pos.direction_to(_new_pos)
	var old_pos = mouse_pos
	mouse_pos = lerp(mouse_pos, _new_pos, delta*4.0)
	speed = (old_pos - mouse_pos).length()
	last_pos = mouse_pos
