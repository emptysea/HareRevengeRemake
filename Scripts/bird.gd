extends CharacterBody2D


const SPEED = 350.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	print ("Ready!")


func _physics_process(delta: float) -> void:
	print ("Process bird...")
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = -1
	if direction:
		velocity.x = direction * SPEED
		print ("Moving at velocity " + str(velocity.x))
	else:
		print ("Not moving...")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func damage():
	if visible == true:
		$hurt.play()
		print ("Bird should be dead!!")
		visible = false
		collision_layer = 0
		collision_mask = 0
