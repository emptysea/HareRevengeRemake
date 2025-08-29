extends Area2D

var spawnPos = global_position
var spawnDir = global_rotation
var animationDir = false

func _ready() -> void:
	global_position = spawnPos
	global_rotation = spawnDir
	$AnimatedSprite2D.flip_h = animationDir
	print ("water spawned")
	print (global_rotation)
	$Expire.start(.1)

func _on_body_entered(body: Node2D) -> void:
	print (body.name)


func _on_expire_timeout() -> void:
	queue_free()
