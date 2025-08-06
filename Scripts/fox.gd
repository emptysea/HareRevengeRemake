extends CharacterBody2D


const SPEED = 350.0
const JUMP_VELOCITY = -400.0
@export var movingRight = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if movingRight:
		velocity.x = 1 * SPEED
		
	elif not movingRight:
		velocity.x = -1 * SPEED
		$AnimatedSprite2D.flip_h = true
	$AnimatedSprite2D.play()
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	print ("got one!")
	pass # Replace with function body.
