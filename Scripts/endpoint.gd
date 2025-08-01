extends Area2D
signal next_level


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Turtle":
		emit_signal("next_level")
	else:
		print("No transition!")
	pass # Replace with function body.
