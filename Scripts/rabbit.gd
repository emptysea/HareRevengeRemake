extends CharacterBody2D

@export var rabbit_health = 3

signal winner

const SPEED = 500.0
const JUMP_VELOCITY = -530.0
@onready var peak_of_jump = false
@onready var moving = false
@onready var facing_left = true
@onready var starting_pos_x = 1056
@onready var ending_pos_x = 93


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if facing_left:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
		
	if not is_on_floor():
		velocity += get_gravity() * delta
		if velocity.y >= 0 and not peak_of_jump:
			peak_of_jump = true
			throw_carrot()
			$AnimatedSprite2D.play("fall")
	else:
		#Make the rabbit jump.
		peak_of_jump = false
		throw_carrot()
		$AnimatedSprite2D.play("jump")
		velocity.y = JUMP_VELOCITY

	if moving:
		var direction = 1
		if facing_left:
			direction = -1
			
		velocity.x = direction * SPEED

		if facing_left and position.x <= ending_pos_x:
			position.x = ending_pos_x
			moving = false
			facing_left = not facing_left
		elif not facing_left and position.x >= starting_pos_x:
			position.x = starting_pos_x
			moving = false
			facing_left = not facing_left
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

#Don't throw carrots while moving
func throw_carrot():
	pass

func damage():
	rabbit_health-=1
	$hurt.play()
	if rabbit_health <= 0:
		print ("You win!!")
		emit_signal("winner")
	else:
		moving = true
