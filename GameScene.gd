extends Area2D

var dragging = false

var inCanvas = false

signal dragsignal;

func _ready():
	connect("dragsignal",self,"_set_drag_pc")

func _process(delta):
	if dragging:
		var mousepos = get_viewport().get_mouse_position()
		self.position = Vector2(mousepos.x, mousepos.y)

func _set_drag_pc():
	dragging=!dragging

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton: # TODO: touch as well
		print(event)		
		print(self)
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("dragsignal")
		elif event.button_index == BUTTON_LEFT and !event.pressed:
			emit_signal("dragsignal")
	elif event is InputEventScreenTouch:
		if event.pressed and event.get_index() == 0:
			self.position = event.get_position()
