tool
extends EditorPlugin

func _enter_tree():
	add_autoload_singleton("HyperLog", "res://addons/hyperlog/hyperlog.tscn")

func _exit_tree():
	remove_autoload_singleton("HyperLog")
