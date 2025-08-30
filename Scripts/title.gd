extends Node

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var game = load("res://Scenes/Game.tscn")
		var gameinstance = game.instantiate()
		get_tree().root.add_child(gameinstance)
		queue_free()
		
