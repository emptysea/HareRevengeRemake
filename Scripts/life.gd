extends Node

signal game_over

@export var life : int = 3

func take_damage(damage: int) -> void:
	for i in damage:
		match life:
			1:
				$Heart3/AnimatedSprite2D.frame = 1
				life = life -1
			2:
				$Heart2/AnimatedSprite2D.frame = 1
				life = life -1
			3:
				$Heart1/AnimatedSprite2D.frame = 1
				life = life - 1
	if life <= 0:
		emit_signal("game_over")

func hide() -> void:
	$Heart1.visible = false
	$Heart2.visible = false
	$Heart3.visible = false

func show() -> void:
	$Heart1.visible = true
	$Heart2.visible = true
	$Heart3.visible = true
