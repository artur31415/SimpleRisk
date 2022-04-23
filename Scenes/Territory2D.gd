extends Node2D


var myTerritory

signal territory_selected

var IsSelected = false

func create(_terr, _position):
	myTerritory = _terr
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
		#print(myTerritory.Name)
		emit_signal("territory_selected", myTerritory.Key)

	# if event is InputEventScreenTouch and event.is_pressed():
	# 	print("here3")
