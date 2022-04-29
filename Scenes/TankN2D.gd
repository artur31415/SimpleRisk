extends Node2D

var myTroops

var IsEnemy = false

signal tank_selected

var IsSelected = false

func SetTerritory(terr_scene):
	position = terr_scene.position
	myTroops.TerritoryKey = terr_scene.myTerritory.Key

func update():
	get_node("TankRTL").text = str(myTroops.Count)

func create(_troops, _position, _IsEnemy):
	myTroops = _troops
	if _position != null:
		position = _position	
		update()
	
	IsEnemy = _IsEnemy
	
	get_node("TankEnemyS").visible = IsEnemy
	get_node("TankAllyS").visible = !IsEnemy
	

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
		emit_signal("tank_selected", myTroops.Key, IsEnemy)
