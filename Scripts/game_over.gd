extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		print ("Reloading scene...")
		for child in get_tree().root.get_children():
			print ("Freeing " + str(child.name))
			child.queue_free()
			
		var game = load("res://Scenes/Game.tscn")
		var gameinstance = game.instantiate()
		gameinstance.name = "Gameroot"
		get_tree().root.add_child(gameinstance)
		queue_free()
