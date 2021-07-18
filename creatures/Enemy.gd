class_name Enemy
extends Spatial
# Base class for all enemy types, all enemies should derive from it.

# Those variables are placeholders and should be changed in derived class
var health = {"max": 2, "current": 1}
var speed
var damage = {"max":5,"min":1 }
var alive : bool
var reached_walking_target : bool
var walking_target : Vector3
var velocity : Vector3

func _ready():
	walking_target = Vector3(20, 0, 20)
	pass 

# Enemy taking damage and dying if needed.
func take_damage(damage_taken):
	health.current -= damage_taken
	alive = bool(health.current > 0)
	
# Healing self by healing use integers pls
func heal_on_self(healing):
	health.current = clamp(healing+health.current, 0, health.max)

# Getting damage that has been done by enemy
func get_damage():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	return randi()%damage.max + damage.min
	
func _process(delta):
	print(get_transform().origin)


