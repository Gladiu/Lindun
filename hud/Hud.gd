extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func Init_Hud():
	pass

func _on_targeting_void():
	$Enemy_Status.visible = false

func _on_targeting_enemy(targeted_enemy):
	$Enemy_Status.visible = true
	if targeted_enemy.alive:
		$Enemy_Status.health((targeted_enemy.health.current/targeted_enemy.health.max))
	else:
		$Enemy_Status.health(0)
