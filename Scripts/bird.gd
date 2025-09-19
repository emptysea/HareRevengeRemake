extends CharacterBody2D


const SPEED = 350.0
const JUMP_VELOCITY = -400.0

enum PATTERN {LINE, SWOOP}

@onready var fly_pattern = PATTERN.LINE

func _ready() -> void:
	print ("Ready!")


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = -1
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if fly_pattern == PATTERN.SWOOP:
		velocity.y = direction * SPEED * -1
	else:
		velocity.y = 0

	move_and_slide()
	
func change_pattern(pattern: PATTERN):
	fly_pattern = pattern
	match fly_pattern:
		PATTERN.LINE:
			$AnimatedSprite2D.play("Line")
		PATTERN.SWOOP:
			$AnimatedSprite2D.play("Swoop")

func damage():
	if visible == true:
		$hurt.play()
		print ("Bird should be dead!!")
		visible = false
		collision_layer = 0
		collision_mask = 0
