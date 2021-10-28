extends Node2D

var dragging = false

var dragging_object

var buddy

var current_level_objects = []
var current_level_wires = []

var current_level

# wire => [object1, object2]
var current_wire_connections_to_objects = {}
# object => { "TerminalA": wire, "TerminalB": wire2 }
var current_object_connections_to_wires = {}

var current_drawing_wire

func _ready():
	$Control/HintButton.connect("pressed", self, "hint_button_pressed")
	$Control/NextLevelButton.connect("pressed", self, "next_level_button_pressed")
	$Control/ResetButton.connect("pressed", self, "reset_button_pressed")
	var buddy_scene = preload("res://Buddy.tscn")
	buddy = buddy_scene.instance()
	add_child(buddy)
	# prepare_level_1()
	prepare_level_2()

func remove_previous_level():
	for obj in current_level_wires:
		obj.free()
	current_level_wires = []
	for obj in current_level_objects:
		obj.free()
	current_level_objects = []

func reset_button_pressed():
	remove_previous_level()
	if current_level == 1:
		prepare_level_1()
	elif current_level == 2:
		prepare_level_2()

func next_level_button_pressed():
	remove_previous_level()
	if current_level == 1:
		prepare_level_2()

func hint_button_pressed():
	if current_level == 1:
		buddy.get_node("Label").text = "Try drawing a wire between the battery and light bulb terminals."
		# TODO: show circle?

func prepare_level_1():
	# $Whatever.save_progress(0)
	current_level = 1
	buddy.get_node("Label").text = "It's a bit dark, can you turn on the light?"
	var battery_scene = preload("res://GameObjects/Battery.tscn")
	var battery = battery_scene.instance()
	battery.position.x = 250
	battery.position.y = 150
	add_child(battery)
	var bulb_scene = preload("res://GameObjects/Bulb.tscn")
	var bulb = bulb_scene.instance()
	bulb.position.x = 250
	bulb.position.y = 250
	add_child(bulb)
	current_level_objects = [battery, bulb]

func prepare_level_2():
	current_level = 2
	buddy.get_node("Label").text = "Can you hook up a switch to my light?"
	var battery_scene = preload("res://GameObjects/Battery.tscn")
	var battery = battery_scene.instance()
	battery.position.x = 250
	battery.position.y = 150
	add_child(battery)
	var bulb_scene = preload("res://GameObjects/Bulb.tscn")
	var bulb = bulb_scene.instance()
	bulb.position.x = 250
	bulb.position.y = 250
	add_child(bulb)
	var switch_scene = preload("res://GameObjects/Switch.tscn")
	var switch = switch_scene.instance()
	switch.position.x = 250
	switch.position.y = 350
	add_child(switch)
	current_level_objects = [battery, bulb, switch]

func finish_level_2():
	if current_level_objects[2].get_node("OnSprite").visible:
		$Control/HintButton.visible = false
		$Control/NextLevelButton.visible = true
		current_level_objects[1].get_node("OffSprite").visible = false
		current_level_objects[1].get_node("OnSprite").visible = true
		buddy.get_node("Label").text = "Aha!"
	else:
		$Control/HintButton.visible = true
		$Control/NextLevelButton.visible = false
		current_level_objects[1].get_node("OffSprite").visible = true
		current_level_objects[1].get_node("OnSprite").visible = false
		buddy.get_node("Label").text = "Can you switch my light on?"

func finish_level_1():
	# save here
	$Control/HintButton.visible = false
	$Control/NextLevelButton.visible = true
	current_level_objects[1].get_node("OffSprite").visible = false
	current_level_objects[1].get_node("OnSprite").visible = true
	buddy.get_node("Label").text = "Ah, thats much better!"

func check_circuit_complete():
	if current_level == 1 && len(current_level_wires) == 2:
		finish_level_1()
	elif current_level == 2 && len(current_level_wires) == 3:
		finish_level_2()
	return false

func _process(delta):
	if dragging_object:
		var mousepos = get_viewport().get_mouse_position()
		dragging_object.position = Vector2(mousepos.x, mousepos.y)
		if dragging_object in current_object_connections_to_wires:
			var object_to_wire_conn_data = current_object_connections_to_wires[dragging_object]
			for terminal in ["TerminalA", "TerminalB"]:
				if terminal in object_to_wire_conn_data && object_to_wire_conn_data[terminal]:
					var wire = object_to_wire_conn_data[terminal]
					# set the point relative to terminal
					var offset = dragging_object.get_node(terminal).position
					# which point to move
					var index = 1
					if dragging_object == current_wire_connections_to_objects[wire][0]:
						index = 0
					wire.set_point_position(index, Vector2(mousepos.x + offset.x, mousepos.y + offset.y))
	elif current_drawing_wire:
		var mousepos = get_viewport().get_mouse_position()
		current_drawing_wire.set_point_position(1, mousepos)

# starts or completes a terminal drawing
# receives something like
# {"object": battery_object, "terminal_name": "TerminalA", "position": Vector2(100,100)}
func terminal_wire_event(terminal_data):
	# TODO: if we click a terminal already hooked up, unhook it
	# TODO: multiple wires from one terminal??
	if !terminal_data:
		return

	# check if terminal is already taken
	# TODO: maybe allow multiple wires from one terminal? (parallel circuits?)
	if terminal_data["object"] in current_object_connections_to_wires:
		var obj_to_wire_conn_data = current_object_connections_to_wires[terminal_data["object"]]
		if terminal_data["terminal_name"] in obj_to_wire_conn_data:
			return
	
	# TODO: error checking if terminal is already taken
	# if we are drawing a wire now, a terminal event means add the wire
	if current_drawing_wire:
		var wire_to_obj_conn_data = current_wire_connections_to_objects[current_drawing_wire]
		# return out if we try to connect an object to itself:
		if wire_to_obj_conn_data[0] == terminal_data["object"]:
			return
		wire_to_obj_conn_data.append(terminal_data["object"])
		current_wire_connections_to_objects[current_drawing_wire] = wire_to_obj_conn_data

		var obj_to_wire_conn_data = {}
		if terminal_data["object"] in current_object_connections_to_wires:
			obj_to_wire_conn_data = current_object_connections_to_wires[terminal_data["object"]]
		obj_to_wire_conn_data[terminal_data["terminal_name"]] = current_drawing_wire
		current_object_connections_to_wires[terminal_data["object"]] = obj_to_wire_conn_data
		
		
		current_drawing_wire.connections.append(terminal_data["object"])
		current_level_wires.append(current_drawing_wire)
		current_drawing_wire = null
	# otherwise, we are starting a new wire
	else:
		var wire_scene = preload("res://GameObjects/Wire.tscn")
		var wire = wire_scene.instance()
		wire.connections.append(terminal_data["object"])
		wire.add_point(Vector2(terminal_data["position"].x, terminal_data["position"].y))
		wire.add_point(Vector2(terminal_data["position"].x+100, terminal_data["position"].y+100))
		add_child(wire)
		current_drawing_wire = wire

		current_wire_connections_to_objects[current_drawing_wire] = [terminal_data["object"]]

		var obj_to_wire_conn_data = {}
		if terminal_data["object"] in current_object_connections_to_wires:
			obj_to_wire_conn_data = current_object_connections_to_wires[terminal_data["object"]]
		obj_to_wire_conn_data[terminal_data["terminal_name"]] = current_drawing_wire
		current_object_connections_to_wires[terminal_data["object"]] = obj_to_wire_conn_data
	check_circuit_complete()

func delete_current_drawing_wire():
	var connected_obj = current_wire_connections_to_objects[current_drawing_wire][0]
	current_wire_connections_to_objects[current_drawing_wire] = null
	var obj_to_wire_conn_data = {}
	obj_to_wire_conn_data = current_object_connections_to_wires[connected_obj]
	for terminal in ["TerminalA", "TerminalB"]:
		if terminal in obj_to_wire_conn_data && obj_to_wire_conn_data[terminal] == current_drawing_wire:
			obj_to_wire_conn_data.erase(terminal)
	current_drawing_wire.free()
	current_drawing_wire = null

func toggle_switch(obj):
	obj.get_node("OffSprite").visible = !obj.get_node("OffSprite").visible
	obj.get_node("OnSprite").visible = !obj.get_node("OnSprite").visible
	check_circuit_complete()

# do an interaction with an object (toggle switch)
func get_interaction_object_overlap(pos):
	for obj in current_level_objects:
		if "object_type" in obj && obj.object_type == "switch":
			var collision = obj.get_node("ActualSwitch").get_node("CollisionShape2D")
			var min_x = collision.global_position.x - collision.shape.extents.x
			var max_x = collision.global_position.x + collision.shape.extents.x
			var min_y = collision.global_position.y - collision.shape.extents.y
			var max_y = collision.global_position.y + collision.shape.extents.y
			if pos.x > min_x && pos.y > min_y && pos.x < max_x && pos.y < max_y:
				toggle_switch(obj)
				return obj
	return null

# gets the object the position overlaps
func get_position_object_overlap(pos):
	# probably will need to do z_index...
	for obj in current_level_objects:
		var collision = obj.get_node("CollisionShape2D")
		var min_x = collision.global_position.x - collision.shape.extents.x
		var max_x = collision.global_position.x + collision.shape.extents.x
		var min_y = collision.global_position.y - collision.shape.extents.y
		var max_y = collision.global_position.y + collision.shape.extents.y
		if pos.x > min_x && pos.y > min_y && pos.x < max_x && pos.y < max_y:
			return obj
	return null

# find which terminal we clicked
func get_terminals_overlap(pos):
	for obj in current_level_objects:
		for terminal in ["TerminalA", "TerminalB"]:
			var collision = obj.get_node(terminal).get_node("CollisionShape2D")
			var min_x = collision.global_position.x - collision.shape.extents.x
			var max_x = collision.global_position.x + collision.shape.extents.x
			var min_y = collision.global_position.y - collision.shape.extents.y
			var max_y = collision.global_position.y + collision.shape.extents.y
			if pos.x > min_x && pos.y > min_y && pos.x < max_x && pos.y < max_y:
				return {"object": obj, "terminal_name": terminal, "position": pos}
	return null

func _input(event):
	if event is InputEventMouseButton:
		# check if mouse is within bounds
		if event.button_index == BUTTON_LEFT and event.pressed:
			# first check if we interact with anything (switch)
			var interaction_object = get_interaction_object_overlap(event.position)
			if interaction_object:
				return
			# check if we are clicked an object
			var overlapping_object = get_position_object_overlap(event.position)
			if current_drawing_wire:
				# TODO: finish drawing a wire if we click an object
				pass
			else:
				dragging_object = overlapping_object
			# if not, check if we are clicking a terminal
			var terminal_data = get_terminals_overlap(event.position)
			# if we click into space while drawing, cancel drawing
			if current_drawing_wire && !terminal_data:
				delete_current_drawing_wire()
			terminal_wire_event(terminal_data)
		elif event.button_index == BUTTON_LEFT and !event.pressed:
			dragging_object = null
	#TODO: touch events...
	#elif event is InputEventScreenTouch:
		#if event.pressed and event.get_index() == 0:
			#self.position = event.position
		

