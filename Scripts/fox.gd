extends CharacterBody2D


const SPEED = 325.0
const JUMP_VELOCITY = -400.0
@export var movingRight = false
@export var stillLoading = true

func _ready() -> void:
	print(str(collision_layer))
	print(str(collision_mask))

func switch_direction() -> void:
	movingRight = not movingRight

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		stillLoading = false
	if not stillLoading:	
		if movingRight:
			velocity.x = 1 * SPEED
			$AnimatedSprite2D.flip_h = false
		
		elif not movingRight:
			velocity.x = -1 * SPEED
			$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play()
	move_and_slide()

func damage() -> void:
	if visible == true:
		$hurt.play()
		print ("Fox should be dead!!")
		visible = false
		collision_layer = 0
		collision_mask = 0
