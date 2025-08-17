extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -530.0
@export var StillLoading: bool

signal took_damage(damage_amount)


func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		StillLoading = false

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction and not StillLoading:
		velocity.x = direction * SPEED
		if velocity.x > 0:
			$AnimatedSprite2D.flip_h = false
		elif velocity.x < 0:
			$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.set_frame_and_progress(0,0)

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	print ("Just hit a " + str(body)) # Replace with function body.
	emit_signal("took_damage",1)
