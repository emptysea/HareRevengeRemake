extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -530.0
enum FACING {LEFT, RIGHT}

@export var StillLoading: bool

@onready var water = load("res://Scenes/water.tscn")
@onready var facingDir = FACING.RIGHT
@onready var is_hiding = false

signal took_damage(damage_amount)
func _ready() -> void:
	$AnimatedSprite2D.play("Walk")

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		StillLoading = false
		
	#Implement hiding in shell.
	if Input.is_action_just_pressed("Hide") and is_on_floor():
		$AnimatedSprite2D.play("Hide")
		pass

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		$Jump.play()
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed("Shoot") and is_on_floor():
		var projectile = water.instantiate()
		projectile.spawnPos = global_position
		if facingDir == FACING.RIGHT:
			projectile.spawnDir = 0
		else:
			var yAdjust = Vector2(0,26)
			projectile.spawnPos = global_position + yAdjust
			projectile.spawnDir = deg_to_rad(180)
		
		call_deferred("add_child",projectile)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction and not StillLoading:
		velocity.x = direction * SPEED
		if velocity.x > 0:
			facingDir = FACING.RIGHT
			$AnimatedSprite2D.flip_h = false
		elif velocity.x < 0:
			facingDir = FACING.LEFT
			$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("Walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.set_frame_and_progress(0,0)

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.visible == true:
		$Hurt.play()
		print ("Just hit a " + str(body)) # Replace with function body.
		emit_signal("took_damage",1)
