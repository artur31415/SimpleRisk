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

func GetTankSceneByTerritoryKey(territory_key):
	for tankScene in myTanks:
		if tankScene.myTroops.TerritoryKey == territory_key:
			return tankScene
	return null

func GetTerritorySceneByKey(territory_key):
	for territoryScene in myTerritories:
		if territoryScene.myTerritory.Key == territory_key:
			return territoryScene
	return null

func SelectTankByKey(tank_key):
	print("SelectTankByKey: ", tank_key)
	for tankScene in myTanks:
		tankScene.IsSelected = tankScene.myTroops.Key == tank_key
		
func SelectTerritoryByKey(territory_key):
	print("SelectTerritoryByKey: ", territory_key)
	var selected_territory_scene = null
	for territoryScene in myTerritories:
		territoryScene.IsSelected = territoryScene.myTerritory.Key == territory_key
		if territoryScene.IsSelected:
			selected_territory_scene = territoryScene
	return selected_territory_scene

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
	var cur_selected = GetSelectedTank()
	if cur_selected == null || cur_selected.myTroops.Key != tank_key:
		print("_on_tank_selected: " + tank_key)
		SelectTankByKey(tank_key)

#FIXME:
func _on_territory_selected(territory_key):
	print("_on_territory_selected: " + territory_key)
	var old_selected_terr = GetSelectedTerritory()
	var new_selected_terr = SelectTerritoryByKey(territory_key)
	if old_selected_terr != null:
		var selected_tank = GetSelectedTank()
		if selected_tank != null:
			if old_selected_terr != new_selected_terr:
				print("here3")
				#TODO: HANDLE ENEMY FIGHTS!
				var dest_tank = GetTankSceneByTerritoryKey(territory_key)
				if dest_tank == null || dest_tank.myTroops.Key == selected_tank.myTroops.Key:
					var verb = "here4:" + selected_tank.myTroops.Key
					if dest_tank != null:
						verb += "::" + dest_tank.myTroops.Key
					print(verb)
					selected_tank.position = new_selected_terr.position
				elif dest_tank.myTroops.Key != selected_tank.myTroops.Key:
					print("here5")
					dest_tank.myTroops.Count += selected_tank.myTroops.Count
					dest_tank.update()
					myTanks.erase(selected_tank)
					selected_tank.queue_free()
				
			SelectTankByKey(null)
			SelectTerritoryByKey(null)


# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(10):
		for y in range(7):
			if randf() < 0.3:
				var new_terr = Territory.new("terr_" + str(x) + "_" + str(y), "terr_" + str(x) + "_" + str(y))
				var new_terr_scene = TerritoryScene.instance()
				new_terr_scene.create(new_terr, Vector2(40 + x * 80, 40 + y * 80))
				new_terr_scene.connect("territory_selected", self, "_on_territory_selected")
				myTerritories.append(new_terr_scene)
				self.add_child(new_terr_scene)

	for x in range(len(myTerritories)):
		if randf() < 0.3:
			var new_troops = Troops.new("troops_" + str(x), "troops_" + str(x), myTerritories[x].myTerritory.Key, floor(rand_range(50, 1000)))
			var new_troops_scene = TankScene.instance()
			new_troops_scene.create(new_troops, myTerritories[x].position)

			new_troops_scene.connect("tank_selected", self, "_on_tank_selected")

			myTanks.append(new_troops_scene)
			add_child(new_troops_scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
