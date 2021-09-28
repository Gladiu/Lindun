extends Node

var player_scene
var player_node
var player_id

var map_scene
var map_node

var golem_scene
var golem_node

func _ready():
	# Setting mouse mode to captured so it doesnt leave the window
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Loading and instancing player scene
	player_scene = load("res://player/Player.tscn")
	player_node = player_scene.instance()
	add_child(player_node)
	player_node.spawn_at(Vector3(10,10,0))
	player_id = player_node.get_instance_id()

	# Loading and instancing map scene
	map_scene = load("res://models/playground/playground.tscn")
	map_node = map_scene.instance()
	add_child(map_node)
	
	# Loading and instancing golem scene # this is temporary
	golem_scene = load("res://creatures/undead/Iron_Golem.tscn")
	golem_node = golem_scene.instance()
	add_child(golem_node)
	golem_node.set_player(player_id)

func _process(delta):
	golem_node.set_walking_target(player_node.get_transform().origin)
