extends Node2D

const Territory = preload("res://scripts/Territory.gd")
const TerritoryScene = preload("res://Scenes/Territory2D.tscn")

const Troops = preload("res://scripts/Troops.gd")
const TankScene = preload("res://Scenes/TankN2D.tscn")

var myTerritories = []
var myTanks = []

var enemyTanks = []

var last_selected_tank = null
var last_selected_terr = null

var enemyTanksDestroyied = 0

func GetTankSceneByKey(tank_key):
	for tankScene in myTanks:
		if tankScene.myTroops.Key == tank_key:
			return tankScene

	for tankScene in enemyTanks:
		if tankScene.myTroops.Key == tank_key:
			return tankScene
	return null

func GetTankSceneByTerritoryKey(territory_key):
	for tankScene in myTanks:
		if tankScene.myTroops.TerritoryKey == territory_key:
			return tankScene

	for tankScene in enemyTanks:
		if tankScene.myTroops.TerritoryKey == territory_key:
			return tankScene
	return null

func GetTerritorySceneByKey(territory_key):
	for territoryScene in myTerritories:
		if territoryScene.myTerritory.Key == territory_key:
			return territoryScene
	return null

func SelectTankByKey(tank_key, is_enemy):
	print("SelectTankByKey: ", tank_key, "; ", is_enemy)
	if is_enemy:
		for tankScene in enemyTanks:
			tankScene.IsSelected = tankScene.myTroops.Key == tank_key
	else:
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

func GetSelectedTank(is_enemy):
	var tanks = myTanks
	if is_enemy:
		tanks = enemyTanks

	for tankScene in tanks:
		if tankScene.IsSelected:
			return tankScene
	return null

func GetSelectedTerritory():
	for territoryScene in myTerritories:
		if territoryScene.IsSelected:
			return territoryScene
	return null


#FIXME:
func _on_tank_selected(tank_key, is_enemy):
	print("_on_tank_selected: ", tank_key, "; ", is_enemy)
	if !is_enemy:
		last_selected_tank = GetSelectedTank(is_enemy)
	SelectTankByKey(tank_key, is_enemy)
	print("+")


func _on_territory_selected(territory_key):
	print("_on_territory_selected: " + territory_key)
	last_selected_terr = GetSelectedTerritory()
	SelectTerritoryByKey(territory_key)
	print("+")


func SpawnNewTanks(occupation_prob, is_enemy):
	for x in range(len(myTerritories)):
		if randf() < occupation_prob and GetTankSceneByTerritoryKey(myTerritories[x].myTerritory.Key) == null:
			var troop_name = "troops_" + str(x) + "_" + str(randf())
			var new_troops = Troops.new(troop_name, troop_name, myTerritories[x].myTerritory.Key, floor(rand_range(50, 1000)))
			var new_troops_scene = TankScene.instance()

			new_troops_scene.create(new_troops, myTerritories[x].position, is_enemy)

			new_troops_scene.connect("tank_selected", self, "_on_tank_selected")

			if is_enemy:
				enemyTanks.append(new_troops_scene)
			else:
				myTanks.append(new_troops_scene)
			add_child(new_troops_scene)

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(10):
		for y in range(7):
			if randf() < 0.3:
				var terr_name = "terr_" + str(x) + "_" + str(y) + "_" + str(randf())
				var new_terr = Territory.new(terr_name, terr_name)
				var new_terr_scene = TerritoryScene.instance()
				new_terr_scene.create(new_terr, Vector2(40 + x * 80, 40 + y * 80))
				new_terr_scene.connect("territory_selected", self, "_on_territory_selected")
				myTerritories.append(new_terr_scene)
				self.add_child(new_terr_scene)
	
	SpawnNewTanks(0.3, false)
	SpawnNewTanks(0.2, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if last_selected_terr != null:
		var new_selected_terr = GetSelectedTerritory()

		var new_selected_my_tank = GetSelectedTank(false)
		var new_selected_enemy_tank = GetSelectedTank(true)

		print(last_selected_tank, " ; ", new_selected_my_tank, " ; ", new_selected_enemy_tank)

		#HANDLE BATTLE
		if new_selected_enemy_tank != null:
			if new_selected_my_tank != null:
				print("here0")
				var myCount = new_selected_my_tank.myTroops.Count
				var enemyCount = new_selected_enemy_tank.myTroops.Count

				new_selected_my_tank.myTroops.Count -= enemyCount
				new_selected_enemy_tank.myTroops.Count -= myCount

				if new_selected_my_tank.myTroops.Count <= 0:
					new_selected_enemy_tank.GainExperience(1)
					new_selected_enemy_tank.update()

					myTanks.erase(new_selected_my_tank)
					new_selected_my_tank.queue_free()
					

				if new_selected_enemy_tank.myTroops.Count <= 0:
					if new_selected_my_tank.myTroops.Count > 0:
						new_selected_my_tank.GainExperience(1)
						new_selected_my_tank.SetTerritory(GetTerritorySceneByKey(new_selected_enemy_tank.myTroops.TerritoryKey))
						new_selected_my_tank.update()
					enemyTanks.erase(new_selected_enemy_tank)
					new_selected_enemy_tank.queue_free()
					enemyTanksDestroyied += 1
					if enemyTanks.empty():
						SpawnNewTanks(0.2, true)
				
		#HANDLE PLAYER MOTION
		elif new_selected_my_tank != null:
			print(new_selected_my_tank.myTroops.TerritoryKey)
			if last_selected_terr != new_selected_terr:
				print("here3")
				var dest_tank = GetTankSceneByTerritoryKey(new_selected_terr.myTerritory.Key)
				if dest_tank == null: # || dest_tank.myTroops.Key == new_selected_my_tank.myTroops.Key:
					var verb = "here4:" + new_selected_my_tank.myTroops.Key
					# if dest_tank != null:
					# 	verb += "::" + dest_tank.myTroops.Key
					print(verb)
					new_selected_my_tank.SetTerritory(new_selected_terr)
				#TODO: IMPROVE THIS MERGING SCHEME
				elif dest_tank.myTroops.Key != last_selected_tank.myTroops.Key:
					print("here5")
					dest_tank.myTroops.Count += last_selected_tank.myTroops.Count
					dest_tank.update()
					myTanks.erase(last_selected_tank)
					last_selected_tank.queue_free()
				
			SelectTankByKey(null, false)
			last_selected_tank = null

		SelectTerritoryByKey(null)
		last_selected_terr = null
		print("===============================")
