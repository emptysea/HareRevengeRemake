extends CharacterBody2D

const SPEED = 200.0

var spawnPos = global_position
var spawnDir = global_rotation
var animationDir = false


func _ready() -> void:
	name = "carrot"
	global_position = spawnPos
	global_rotation = spawnDir
	visible = true
	
func _process(delta: float) -> void:
	var direction = -1
	if animationDir:
		direction = 1
	position.x += direction * SPEED * delta

func damage():
	pass
	
func destroy():
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	destroy()
