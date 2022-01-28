extends Resource
class_name ValueTracker

var node:Node
var property := ""
var property_name := ""
var backlog := []

var max_log_length := 1024

enum {NONE, FORMAT_STRING, INT, BOOL, ROUND, ANGLE}
var format := 0
var format_string := ""

func _init(node:Node, property:String, parent:Node = null):
	self.node = node
	var cast_i = property.find(">")
	if cast_i != -1:
		self.property = property.substr(0, cast_i)
		
		var format_argument = property.substr(cast_i + 1, property.length())
		format = FORMAT_STRING
		
		if format_argument.begins_with("%"):
			format = FORMAT_STRING
			format_string = format_argument
		else:
			match format_argument:
				"int":
					format = INT
				"bool":
					format = BOOL
				"round":
					format = ROUND
				"angle":
					format = ANGLE
	else:
		self.property = property
	
	if parent and node != parent:
		self.property_name = str(parent.get_path_to(node)) + " > " + self.property
	else:
		self.property_name = self.property

func get_value():
	return node.get_indexed(property)

func format(value):
	if format == NONE:
		return value
	else:
		match format:
			FORMAT_STRING:
				if value is Vector2:
					return str("(",
							format_string % value.x, ", ",
							format_string % value.y,
						")")
				elif value is Vector3:
					return str("(",
							format_string % value.x, ", ",
							format_string % value.y, ", ",
							format_string % value.z,
						")")
				return format_string % value
			INT:
				return int(value)
			BOOL:
				return bool(value)
			ROUND:
				if value is Vector2 or value is Vector3:
					return value.round()
				return round(value)
			ANGLE:
				if value is Vector2:
					return value.angle()
				return value
	

func store_value():
	backlog.push_front(get_value())
	while backlog.size() > max_log_length:
		backlog.pop_back()
