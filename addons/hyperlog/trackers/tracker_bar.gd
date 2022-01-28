extends Tracker
class_name TrackerBar

var range_min := 0
var range_max := 10

var bars := []
var labels := []

func _process(delta):
	if not container.tracking: return
	for i in trackers.size():
		var tracker = trackers[i]
		
		var value = tracker.get_value()
		var bar = bars[i]
		bar.value = value

func add_tracker(property:String, node:Node)->ValueTracker:
	var tracker = .add_tracker(property, node)
	var label = Label.new()
	add_child(label)
	label.text = tracker.property_name
	labels.push_back(label)
	
	var bar = ProgressBar.new()
	bar.rect_min_size.y = 20
	bar.min_value = range_min
	bar.max_value = range_max
	bar.percent_visible = false
	add_child(bar)
	bars.push_back(bar)
	return tracker

func set_range(value_min, value_max)->TrackerBar:
	range_min = value_min
	range_max = value_max
	
	for bar in bars:
		bar.min_value = range_min
		bar.max_value = range_max
	return self

func hide_labels()->TrackerBar:
	for label in labels:
		label.visible = false
	return self

func show_labels()->TrackerBar:
	for label in labels:
		label.visible = true
	return self

#func remove_tracker(tracker):
#	name_container.remove_child(name_container.get_child(0))
#	value_container.remove_child(value_container.get_child(0))
