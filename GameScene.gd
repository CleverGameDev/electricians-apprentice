extends Node2D

var dragging = false

var dragging_object

var buddy

var current_level_objects = []
var current_level_wires = []

var current_level

# wire => [object1, object2]
var current_wire_connections_to_objects = {}
# object => { "TerminalA": wire, "TerminalB": wire2, "TerminalC": wire3 }
var current_object_connections_to_wires = {}

var current_drawing_wire

func _ready():
	$Control/HintButton.connect("pressed", self, "hint_button_pressed")
	$Control/NextLevelButton.connect("pressed", self, "next_level_button_pressed")
	$Control/ResetButton.connect("pressed", self, "reset_button_pressed")
	var buddy_scene = preload("res://Buddy.tscn")
	buddy = buddy_scene.instance()
	add_child(buddy)
	#prepare_level_1()
	prepare_level_4()

func remove_previous_level():
	$Control/HintButton.visible = true
	$Control/NextLevelButton.visible = false
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
	elif current_level == 3:
		prepare_level_3()
	elif current_level == 4:
		prepare_level_4()
	elif current_level == 5:
		prepare_level_5()

# only god can judge me
func next_level_button_pressed():
	remove_previous_level()
	if current_level == 1:
		prepare_level_2()
	elif current_level == 2:
		prepare_level_3()
	elif current_level == 3:
		prepare_level_4()
	elif current_level == 4:
		prepare_level_5()

func hint_button_pressed():
	if current_level == 1:
		buddy.get_node("Label").text = "Try drawing a wire between the battery and light bulb terminals."
	elif current_level == 2:
		buddy.get_node("Label").text = "Try connecting everything up. Reset in the upper left if you make a mistake."
	elif current_level == 3:
		buddy.get_node("Label").text = "Try connecting everything up. Reset in the upper left if you make a mistake."
	elif current_level == 4:
		buddy.get_node("Label").text = "The component with 3 dots can connect multiple wires."
	elif current_level == 5:
		buddy.get_node("Label").text = "The component with 3 dots can connect multiple wires. Make sure the switches are in separate parallel circuits."

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

func prepare_level_3():
	current_level = 3
	buddy.get_node("Label").text = "Let's power two bulbs!"
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
	var bulb2 = bulb_scene.instance()
	bulb2.position.x = 250
	bulb2.position.y = 350
	add_child(bulb2)
	current_level_objects = [battery, bulb, bulb2]

func prepare_level_4():
	current_level = 4
	buddy.get_node("Label").text = "Let's power two bulbs in a parallel circuit!"
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
	var bulb2 = bulb_scene.instance()
	bulb2.position.x = 250
	bulb2.position.y = 350
	add_child(bulb2)
	var three_way_conn_scene = preload("res://GameObjects/ThreeWayConnection.tscn")
	var three_way_conn = three_way_conn_scene.instance()
	three_way_conn.position.x = 350
	three_way_conn.position.y = 150
	add_child(three_way_conn)
	var three_way_conn2 = three_way_conn_scene.instance()
	three_way_conn2.position.x = 350
	three_way_conn2.position.y = 250
	add_child(three_way_conn2)

	current_level_objects = [battery, bulb, bulb2, three_way_conn, three_way_conn2]

func prepare_level_5():
	current_level = 5
	buddy.get_node("Label").text = "Two switches must independently operate two bulbs."
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
	var bulb2 = bulb_scene.instance()
	bulb2.position.x = 250
	bulb2.position.y = 350
	add_child(bulb2)
	var three_way_conn_scene = preload("res://GameObjects/ThreeWayConnection.tscn")
	var three_way_conn = three_way_conn_scene.instance()
	three_way_conn.position.x = 350
	three_way_conn.position.y = 150
	add_child(three_way_conn)
	var three_way_conn2 = three_way_conn_scene.instance()
	three_way_conn2.position.x = 350
	three_way_conn2.position.y = 250
	add_child(three_way_conn2)
	var switch_scene = preload("res://GameObjects/Switch.tscn")
	var switch = switch_scene.instance()
	switch.position.x = 350
	switch.position.y = 350
	add_child(switch)
	var switch2 = switch_scene.instance()
	switch2.position.x = 450
	switch2.position.y = 250
	add_child(switch2)
	#TODO: also need a resistor
	current_level_objects = [battery, bulb, bulb2, three_way_conn, three_way_conn2, switch, switch2]


func finish_level_4():
	$Control/HintButton.visible = false
	$Control/NextLevelButton.visible = true
	current_level_objects[1].get_node("OffSprite").visible = false
	current_level_objects[1].get_node("OnSprite").visible = true
	current_level_objects[2].get_node("OffSprite").visible = false
	current_level_objects[2].get_node("OnSprite").visible = true
	buddy.get_node("Label").text = "Very good. This circuit is unparalled!"

func finish_level_3():
	$Control/HintButton.visible = false
	$Control/NextLevelButton.visible = true
	current_level_objects[1].get_node("OffSprite").visible = false
	current_level_objects[1].get_node("OnSprite").visible = true
	current_level_objects[2].get_node("OffSprite").visible = false
	current_level_objects[2].get_node("OnSprite").visible = true
	buddy.get_node("Label").text = "Yes, nice and bright!"

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


func turn_object_on(obj, is_on):
	obj.get_node("OffSprite").visible = !is_on
	obj.get_node("OnSprite").visible = is_on

# turns on bulbs if they are connected
func check_bulbs():
	for obj in current_level_objects:
		if "object_type" in obj && obj.object_type == "battery":
			# TODO: check for battery blow up!
			continue
		elif "object_type" in obj && obj.object_type == "bulb":
			var is_on = bulb_is_on(obj)
			print("the bulb is")
			print(is_on)
			turn_object_on(obj, is_on)

func switch_is_on(obj):
	print("checking if switch is on")
	print(obj.get_node("OnSprite").visible)
	return obj.get_node("OnSprite").visible

func are_two_terminals_connected(obj):
	if !(obj in current_object_connections_to_wires):
		return false
	var current_obj_to_wire_data = current_object_connections_to_wires[obj]
	var num_terminals_in_obj = 0
	for terminal in ["TerminalA", "TerminalB", "TerminalC"]:
		if terminal in current_obj_to_wire_data && current_obj_to_wire_data[terminal]:
			num_terminals_in_obj += 1
	return num_terminals_in_obj > 1

# luckily, we only have to check battery -> 3 way -> 3 way -> battery. maybe switch?
func check_battery_blow_up(battery):
	# TODO: check blowup!
	if are_two_terminals_connected(battery):
		var current_wire = current_object_connections_to_wires[battery]["TerminalA"]

	return false

# takes a bulb
# returns if it is powered
func bulb_is_on(bulb):
	# TODO: check if bulb is connected both ways to the same 3 way conn
	# if not, it is not on
	var has_battery = false
	if bulb in current_object_connections_to_wires:
		# start at TerminalA
		# loop through wires
		# if we hit a battery before TerminalB,
		# we are powered
		var seen_objs = { bulb: true }
		var seen_wires = {}
		print("checking bulb")
		print("checking bulb")
		print("checking bulb")
		if are_two_terminals_connected(bulb):
			print("builb has 2 terms")
			var current_wire = current_object_connections_to_wires[bulb]["TerminalA"]
			if len(current_wire_connections_to_objects[current_wire]) != 2:
				print("wire has 1 conn")
				return false
			seen_wires[current_wire] = true
			var current_obj = current_wire_connections_to_objects[current_wire][0]
			if current_obj == bulb:
				current_obj = current_wire_connections_to_objects[current_wire][1]
			while !(current_obj in seen_objs):
				print("checking nxt obj")
				print(current_obj)
				print(current_obj.object_type)
				seen_objs[current_obj] = true
				# 2 terminals must be connected
				if !are_two_terminals_connected(current_obj):
					print("current obj is not fully in")
					return false
				# check 3 way connectors
				var next_wire
				if "TerminalA" in current_object_connections_to_wires[current_obj] && current_object_connections_to_wires[current_obj]["TerminalA"]:
					print("trying term a")
					next_wire = current_object_connections_to_wires[current_obj]["TerminalA"]
				if !next_wire || current_wire == next_wire:
					if "TerminalB" in current_object_connections_to_wires[current_obj] && current_object_connections_to_wires[current_obj]["TerminalB"]:
						print("trying term b")
						next_wire = current_object_connections_to_wires[current_obj]["TerminalB"]

				if !next_wire || current_wire == next_wire:
					if "TerminalC" in current_object_connections_to_wires[current_obj] && current_object_connections_to_wires[current_obj]["TerminalC"]:
						next_wire = current_object_connections_to_wires[current_obj]["TerminalC"]
				
				if !next_wire:
					return false
				if len(current_wire_connections_to_objects[next_wire]) != 2:
					print("next wire on obj is not fully in")
					return false
				
				var next_obj = current_wire_connections_to_objects[next_wire][0]
				if current_obj == next_obj:
					next_obj = current_wire_connections_to_objects[next_wire][1]
				print("the next obj is")
				print(next_obj)
				print(next_obj.object_type)
				#if current
				if "object_type" in current_obj:
					if current_obj.object_type == "switch" && !(switch_is_on(current_obj)):
						print("got switch, switch is off")
						return false
					if current_obj.object_type == "battery":
						print("got battery!")
						has_battery = true
				current_obj = next_obj
				current_wire = next_wire
			return has_battery
		else:
			print("bulb has 1 terminal")
			return false
	else:
		print("bulb not connected?")
		return false

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
	elif current_level == 2:
		if len(current_level_wires) == 3:
			finish_level_2()
		else:
			check_bulbs()
	elif current_level == 3:
		if len(current_level_wires) == 3:
			finish_level_3()
		else:
			check_bulbs()
	elif current_level == 4:
		if len(current_level_wires) == 6:
			# check if bulbs are indeed in parallel
			if check_parallel():
				buddy.get_node("Label").text = "This is close! These bulbs are in series, not parallel."
			else:
				finish_level_4()
				return false
		else:
			check_bulbs()
	elif current_level == 5:
		check_bulbs()
		# TODO:
		# 3 ways must be only to battery
		# switch must be separate (cannot be on same loop?)
		# .... very complicated.
		return false
	return false

# on parallel circuit level, it is sufficient to just ensure that the 2 bulbs dont touch 
func check_parallel():
	for obj in current_level_objects:
		if "object_type" in obj && obj.object_type == "bulb":
			print("found a bulb")
			if !(are_two_terminals_connected(obj)):
				return false
			var wire = current_object_connections_to_wires[obj]["TerminalA"]
			if current_wire_connections_to_objects[wire][0].object_type == "bulb" && current_wire_connections_to_objects[wire][1].object_type == "bulb":
				print("first wire is both")
				return true
			wire = current_object_connections_to_wires[obj]["TerminalB"]
			var second_wire_is_both = current_wire_connections_to_objects[wire][0].object_type == "bulb" && current_wire_connections_to_objects[wire][1].object_type == "bulb"
			print("second wire is")
			print(second_wire_is_both)
			return second_wire_is_both

func _process(delta):
	if dragging_object:
		var mousepos = get_viewport().get_mouse_position()
		dragging_object.position = Vector2(mousepos.x, mousepos.y)
		if dragging_object in current_object_connections_to_wires:
			var object_to_wire_conn_data = current_object_connections_to_wires[dragging_object]
			for terminal in ["TerminalA", "TerminalB", "TerminalC"]:
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
	if !terminal_data:
		return
	# check if terminal is already taken
	if terminal_data["object"] in current_object_connections_to_wires:
		var obj_to_wire_conn_data = current_object_connections_to_wires[terminal_data["object"]]
		if terminal_data["terminal_name"] in obj_to_wire_conn_data:
			buddy.get_node("Label").text = "Ah, these terminals can only connect one wire. You can reset in the upper left, if you want."
			return
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
	for terminal in ["TerminalA", "TerminalB", "TerminalC"]:
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
		for terminal in ["TerminalA", "TerminalB", "TerminalC"]:
			if terminal == "TerminalC" && (!("object_type" in obj) || obj.object_type != "three_way_connection"):
				continue
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
		

