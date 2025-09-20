extends CharacterBody2D

@export var rabbit_health = 3

signal winner

const SPEED = 1000.0
const JUMP_VELOCITY = -530.0
@onready var peak_of_jump = false
@onready var moving = false
@onready var facing_left = true
@onready var starting_pos_x = 1056
@onready var ending_pos_x = 93
@onready var stillloading = true
@onready var carrot = load("res://Scenes/carrot.tscn")


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
		if not stillloading:
			throw_carrot()
		stillloading = false
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
	#Instantiate new carrot.  TODO: set spawn position.
	var projectile = carrot.instantiate()
	projectile.spawnPos = position

	if facing_left:
		projectile.spawnDir = 0
		projectile.animationDir = false
	else:
		var yAdjust = Vector2(0,0)
		projectile.spawnPos = global_position + yAdjust
		projectile.spawnDir = deg_to_rad(180)
		projectile.animationDir = true
	get_tree().root.add_child(projectile)
	#call_deferred("topoftree.add_child",projectile)

func damage():
	rabbit_health-=1
	$hurt.play()
	if rabbit_health <= 0:
		print ("You win!!")
		emit_signal("winner")
	else:
		moving = true
