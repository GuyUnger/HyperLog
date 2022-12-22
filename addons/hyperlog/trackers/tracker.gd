class_name Tracker extends Control

var trackers := []
var container

func track(properties, node = null):
	if node is String:
		if node.ends_with("/*"):
			node = container.parent_node.get_node(node.substr(0, node.length() - 2))
			for child in node.get_children():
				track(properties, child)
			return
		node = container.parent_node.get_node(node)
	elif node == null and container.parent_node:
		node = container.parent_node
	
	if properties is String:
		add_tracker(properties, node)
	elif properties is Array:
		for i in properties.size():
			add_tracker(properties[i], node)

func add_tracker(property:String, node:Node) -> ValueTracker:
	var tracker = ValueTracker.new(node, property, container.parent_node)
	trackers.push_back(tracker)
	return tracker

func remove_tracker(tracker):
	trackers.remove_at(tracker)

func set_height(value:float) -> Tracker:
	custom_minimum_size.y = value
	size.y = value
	return self

func trackers_store_value():
	for tracker in trackers:
		tracker.store_value()
