extends Tracker
class_name TrackerText

onready var name_container = $name_container
onready var value_container = $value_container

func _process(delta):
	if not container.tracking: return
	for i in trackers.size():
		var tracker = trackers[i]
		var label_name = name_container.get_child(i)
		var label_value = value_container.get_child(i)
		
		var property_name = tracker.property_name
		var value = tracker.format(tracker.get_value())
		label_name.text = property_name
		label_value.text = str(value)
		if value is bool:
			label_value.modulate = Color.greenyellow if value else Color.tomato
		else:
			label_value.modulate = Color.white

func add_tracker(property:String, node:Node = null)->ValueTracker:
	_add_label(name_container)
	_add_label(value_container)
	return .add_tracker(property, node)

func _add_label(parent):
	var label = Label.new()
	parent.add_child(label)

func remove_tracker(tracker):
	name_container.remove_child(name_container.get_child(0))
	value_container.remove_child(value_container.get_child(0))
