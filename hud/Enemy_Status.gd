extends Node2D


var _scale = Vector2(3, 3)


# Called when the node enters the scene tree for the first time.
func _ready():
	$enemy_health_bar.set_scale(_scale)
	$enemy_health_border.set_scale(_scale)


func health(health):
	$enemy_health_bar.scale.x = _scale.x * health
