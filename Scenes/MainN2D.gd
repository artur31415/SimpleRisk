extends Node2D

const Territory = preload("res://scripts/Territory.gd")
const TerritoryScene = preload("res://Scenes/Territory2D.tscn")

var myTerritories = []


# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(4):
		var new_terr = Territory.new("terr_" + str(x), "terr_" + str(x))
		var new_terr_scene = TerritoryScene.instance()
		new_terr_scene.create(new_terr)
		myTerritories.append(new_terr_scene)
		add_child(new_terr_scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
