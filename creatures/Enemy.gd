extends Spatial
# Base class for all enemy types, all enemies should derive from it.

# Those variables are placeholders and should be changed in derived class
var health = {"max": 2, "current": 1}
var damage = {"max":5,"min":1 }
var alive := bool()

func _ready():
	pass 

# Used to set enemy to be aggresive on something or someone
func make_aggro_on(_object):
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
	
func set_collision_shape(shape):
	add_child(shape)
