class_name Undead
extends "res://creatures/Enemy.gd"



func _ready():
	pass

func _process(delta):
	reached_walking_target = bool((walking_target - get_transform().origin ).length() < 2*radius)
	print((walking_target - get_transform().origin ).length())

func on_ground():
	return $Feets.get_overlapping_bodies().size() > 0

func _physics_process(delta):
	
	# First process falling from edge and any involountary movement
	if on_ground():
		air_time = 0
		velocity.y = 0
	else:
		air_time += delta
		velocity.y = air_time * gravity.y

	# Movement is a vector defining where undead wants to move in next frame
	var movement = Vector3()
	if !reached_walking_target:
		movement = (walking_target - get_transform().origin).normalized()*speed + gravity
		var collider = $Body.move_and_collide(movement*delta, true, true, true)
		if collider is KinematicCollision:
			movement = movement.slide(collider.get_normal())
			movement = movement.normalized()*speed
	set_transform(Transform(get_transform().basis, get_transform().origin + movement))
