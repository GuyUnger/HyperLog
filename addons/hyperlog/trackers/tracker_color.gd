extends Tracker
class_name TrackerColor

onready var label = $Label

var backlog = []

var max_lines = 2048

func _process(delta):
	if not container.tracking: return
	for tracker in trackers:
		backlog.push_front(str(tracker.property, "\t", tracker.format(tracker.get_value()) ) )
	while backlog.size() > max_lines:
		backlog.pop_back()
	
	label.text = ""
	for line in backlog:
		label.text = str(label.text, line, "\n")
