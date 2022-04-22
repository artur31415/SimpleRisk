extends Node2D

const Territory = preload("res://scripts/Territory.gd")
const TerritoryScene = preload("res://Scenes/Territory2D.tscn")

const Troops = preload("res://scripts/Troops.gd")
const TankScene = preload("res://Scenes/TankN2D.tscn")

var myTerritories = []
var myTanks = []

func GetTankSceneByKey(tank_key):
	for tankScene in myTanks:
		if tankScene.myTroops.Key == tank_key:
			return tankScene
	return null

func GetTerritorySceneByKey(territory_key):
	for territoryScene in myTerritories:
		if territoryScene.myTerritory.Key == territory_key:
			return territoryScene
	return null

func SelectTankByKey(tank_key):
	for tankScene in myTanks:
		tankScene.IsSelected = tankScene.myTroops.Key == tank_key
		
func SelectTerritoryByKey(territory_key):
	for territoryScene in myTerritories:
		territoryScene.IsSelected = territoryScene.myTerritory.Key == territory_key

func GetSelectedTank():
	for tankScene in myTanks:
		if tankScene.IsSelected:
			return tankScene
	return null

func GetSelectedTerritory():
	for territoryScene in myTerritories:
		if territoryScene.IsSelected:
			return territoryScene
	return null


func _on_tank_selected(tank_key):
	print("_on_tank_selected: " + tank_key)
	SelectTankByKey(tank_key)

func _on_territory_selected(territory_key):
	print("_on_territory_selected: " + territory_key)
	var old_selected_terr = GetSelectedTerritory()
	if old_selected_terr != null:
		SelectTerritoryByKey(territory_key)
		#FIXME:

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(4):
		var new_terr = Territory.new("terr_" + str(x), "terr_" + str(x))
		var new_terr_scene = TerritoryScene.instance()
		new_terr_scene.create(new_terr, Vector2(40 + x * 80, 40))
		new_terr_scene.connect("territory_selected", self, "_on_territory_selected")
		myTerritories.append(new_terr_scene)
		self.add_child(new_terr_scene)

	var new_troops = Troops.new("troops_", "troops_", myTerritories[0].myTerritory.Key)
	var new_troops_scene = TankScene.instance()
	new_troops_scene.create(new_troops, myTerritories[0].position)

	new_troops_scene.connect("tank_selected", self, "_on_tank_selected")

	myTanks.append(new_troops_scene)
	add_child(new_troops_scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
