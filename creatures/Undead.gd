class_name Undead
extends "res://creatures/Enemy.gd"



func _ready():
	pass

func _process(delta):
	# Calculating whether we actually reached the target
	reached_walking_target = bool((walking_target - get_transform().origin ).dot(velocity) < 0) or bool((walking_target - get_transform().origin).length() < 3)

# Checking if feets are on ground to process falling physics and movement
func on_ground():
	return $Feets.get_overlapping_bodies().size() > 0

func _physics_process(delta):
	var movement = Vector3()
	# Rotating model on horizontal plane so it faces where it goes
	# Using atan2 becouse it gives out sign of the angle
	desired_y_angle = atan2(-(walking_target - get_transform().origin).z, (walking_target - get_transform().origin).x)
	var diff_angle = (desired_y_angle - $Model.get_rotation().y)*delta*rotation_speed
	$Model.set_rotation(Vector3(0, $Model.get_rotation().y + diff_angle , 0))
	if abs($Model.get_rotation().y - desired_y_angle) < deg2rad(30) or velocity.length() != 0:
		# Calculating horizontal movement vector and handling collisions
		# Undead is moving to walking_target derived from Enemy
		if !reached_walking_target:
			movement = (walking_target - get_transform().origin).normalized()*speed
			var collider = move_and_collide(movement*delta, true, true, true)
			if collider is KinematicCollision:
				movement = movement.slide(collider.get_normal())
		# Calculating vertical movement, not taking into account jumping
		if !on_ground():
			air_time += delta
			movement.y = -gravity * air_time

	# Moving entire node. Kinematicbody should be root, script wont run otherwise
	velocity = move_and_slide(movement)




