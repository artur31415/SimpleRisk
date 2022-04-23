extends Node2D

var myTroops

signal tank_selected

var IsSelected = false

func create(_troops, _position):
	myTroops = _troops
	if _position != null:
		position = _position	
	get_node("TankRTL").text = str(myTroops.Count)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StaticBody2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
		and event.button_index == BUTTON_LEFT \
		and event.pressed:
		#print(myTroops.Name)
		emit_signal("tank_selected", myTroops.Key)
