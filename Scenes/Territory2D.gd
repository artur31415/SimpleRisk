extends Node2D


var currentTerritory

func create(_terr, _position):
	currentTerritory = _terr
	position = _position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StaticBody2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
		and event.button_index == BUTTON_LEFT \
		and event.pressed:
		print(currentTerritory.Name)

	# if event is InputEventScreenTouch and event.is_pressed():
	# 	print("here3")
