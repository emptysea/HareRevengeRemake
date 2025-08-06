extends CharacterBody2D


const SPEED = 350.0
const JUMP_VELOCITY = -400.0
var movingRight = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if movingRight:
		velocity.x = 1 * SPEED
	elif not movingRight:
		velocity.x = -1 * SPEED

	move_and_slide()
