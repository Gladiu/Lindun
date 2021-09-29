extends Node

var player_scene
var player_node

var map_scene
var map_node

var enemies_array = []
var max_enemy_ammount = 1 

func _ready():
	# Setting mouse mode to captured so it doesnt leave the window
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Loading and instancing player scene
	player_scene = load("res://player/Player.tscn")
	player_node = player_scene.instance()
	add_child(player_node)
	player_node.spawn_at(Vector3(0,10,0))

	# Loading and instancing map scene
	map_scene = load("res://models/playground/playground.tscn")
	map_node = map_scene.instance()
	add_child(map_node)
	
	for i in range(0,max_enemy_ammount):
		# Loading and instancing individual enemy scenes before adding them
		# to global enemy array which contains all enemies
		var temp_enemy_scene = load("res://creatures/undead/Iron_Golem.tscn")
		enemies_array.append(temp_enemy_scene.instance())
		add_child(enemies_array[i])

func _process(delta):
	for enemy in enemies_array:
		enemy.walk_to(player_node.get_position())
