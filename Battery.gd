extends StaticBody2D

var dragging = false

var can_grab = false

signal dragsignal(object);
var signal_name

func _ready():
	signal_name = "dragsignal" + self.name
	connect("dragsignal",self,"_set_drag_pc")
	connect("mouse_entered", self, "entered")
	connect("mouse_exited", self, "exited")

func _process(delta):
	if dragging && can_grab:
		var mousepos = get_viewport().get_mouse_position()
		self.position = Vector2(mousepos.x, mousepos.y)

func _set_drag_pc(object):
	if object == self:
		dragging=!dragging

func entered():
	print("entered")
	can_grab = true

func exited():
	print("exited")
	can_grab = false

func _input(event):
	if event is InputEventMouseButton:
		# check if mouse is within bounds
		if event.button_index == BUTTON_LEFT and event.pressed:
			if can_grab:
				emit_signal("dragsignal", self)
		elif event.button_index == BUTTON_LEFT and !event.pressed:
			emit_signal("dragsignal", self)
	elif event is InputEventScreenTouch:
		if event.pressed and event.get_index() == 0:
			self.position = event.get_position()
		

