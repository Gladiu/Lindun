extends KinematicBody

var mouse_sensitivity := Vector2()
var velocity := Vector3()
var ground_friction := float()
var air_friction := float()
var gravity := Vector3()
var inertial_velocity := Vector3()
var air_time := float()
var jump_speed := int()
var walking_speed := float()
var jumped := bool()
var inertia := Vector3()
var previous_position := Vector3()
var max_x_view_angle := float()


func _ready():
	set_mouse_sensitivity(Vector2(get_viewport().get_visible_rect().size.x, get_viewport().get_visible_rect().size.y).normalized()/10)
	gravity = Vector3(0, -9.81, 0)
	air_time = 0
	jump_speed = 4
	ground_friction = .1
	air_friction = .05
	walking_speed = 6.0
	jumped = false
	max_x_view_angle = 90


func set_mouse_sensitivity(new_sens:= Vector2()):
	mouse_sensitivity = new_sens

func get_mouse_sensitivity():
	return mouse_sensitivity
	
func spawn_at(spawn_vector: Vector3):
	set_transform(Transform(Basis(get_transform().basis), spawn_vector))

func clip_vector(vector: Vector3, clip: float):
	vector.x = clamp(vector.x, -clip, clip)
	vector.y = clamp(vector.y, -clip, clip)
	vector.z = clamp(vector.z, -clip, clip)
	return vector
	
func on_ground():
	return $Feets.get_overlapping_bodies().size() > 0
	
func _unhandled_input(event):
	# Defining view orientation
	if event is InputEventMouseMotion:
		# Defining angle to rotate the view based on 2D X and Y movement
		# Reminder that in mathematics cartesian axis Z is up, and here Y is up becouse it makes more sense in computer gfx
		var angle_x = $View.get_rotation_degrees().x
		var rotx
		# Limiting max x angle to 90 degrees so the camera works as expected
		if abs(angle_x - mouse_sensitivity.y * event.get_relative().y) < max_x_view_angle:
			rotx = angle_x - mouse_sensitivity.y * event.get_relative().y 
		else:
			rotx = clamp(angle_x, -max_x_view_angle, max_x_view_angle)
		var roty = -mouse_sensitivity.x * event.get_relative().x + $View.get_rotation_degrees().y
		$View.set_rotation_degrees(Vector3(rotx, roty, 0))

func _physics_process(delta):
	# Handling movement from keyboard
	# Check if any movement happened at all
	var wish_dir = Vector3()
	
	# Defining wished directory vector in view coordinates
	wish_dir.x = int(Input.is_action_pressed("movement_strafe_right")) - int(Input.is_action_pressed("movement_strafe_left"))
	wish_dir.y = int(Input.is_action_pressed("movement_jump") )
	wish_dir.z = int(Input.is_action_pressed("movement_backward")) - int(Input.is_action_pressed("movement_forward"))
	
	# Translating view coordinates to player coordinates
	var angle = $View.get_transform().basis.get_euler().y
	var new_velocity = Vector3()
	new_velocity.x = wish_dir.z * sin(angle) + wish_dir.x * cos(angle)
	new_velocity.z = wish_dir.z * cos(angle) - wish_dir.x * sin(angle)
	
	# Saving original direction of velocity to keep track when to stop applying friction, if dot product of original velocity and current velocity
	# is negative it means it has opposite direction and we can stop applying friction
	if Input.is_action_pressed("movement_strafe_right") or Input.is_action_pressed("movement_strafe_left") or Input.is_action_pressed("movement_backward") or Input.is_action_pressed("movement_forward"):
		inertia = velocity

	var next_velocity = new_velocity+velocity*0.8 - inertia.normalized() * ( ground_friction * float(on_ground()) + air_friction * float(!on_ground()) )
	velocity = (next_velocity )* float(inertia.dot(next_velocity) >= 0)
	velocity = clip_vector(velocity, walking_speed)

	# Jumping
	# if we are not on ground then substract gravity from vel.y add starting velocity of jump if we jumped
	# and if we collided with a plane thats more than 45 degrees from horizontal plane -> slide

	# Check if we are eligible to jump and if we are adjust velocity
	if on_ground():
		air_time = 0
		jumped = false
		velocity.y = 0
	else:
		air_time += delta
		velocity.y = int(jumped)*jump_speed + air_time * gravity.y

	if Input.is_action_pressed("movement_jump") and !jumped:
		air_time = 0
		jumped = true
		velocity.y = wish_dir.y * jump_speed

	# Handling collisions 
	var collision = move_and_collide(velocity*delta, true, true, true)
	if collision is KinematicCollision:
		velocity = velocity.slide(collision.get_normal())
		#if collision.get_normal().angle_to(-gravity) > PI/2 :
		#	velocity.y = 0

	move_and_slide(velocity, gravity, false, 1, 0.78, true)

