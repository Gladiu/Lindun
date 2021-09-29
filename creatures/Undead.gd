class_name Undead
extends "res://creatures/Enemy.gd"



func _ready():
	pass

func _process(delta):
	reached_walking_target = bool((walking_target - get_transform().origin ).dot(velocity) < 0)
	print((walking_target - get_transform().origin ).dot(velocity) )

func _physics_process(delta):
	if !reached_walking_target:
		var movement = (get_transform().origin - walking_target).normalized()*speed
		var collider = $Body.move_and_collide(movement*delta, true, true, true)
		if collider is KinematicCollision:
			movement = movement.slide(collider.get_normal())
		velocity = $Body.move_and_slide(movement)
		set_transform(Transform(get_transform().basis, get_transform().origin + velocity))
