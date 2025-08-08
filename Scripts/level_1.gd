extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	$FoxTimer.start(2)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var foxXPos = $Fox.global_position.x
	var turtleXPos = $Turtle.global_position.x
	var xDistance = abs(foxXPos - turtleXPos)

func _on_fox_timer_timeout() -> void:
	#Create our first fox
	#TODO: Programmatically find the bounds of the level, in case we want to change resolutions.
	var enemyLocation = $Turtle/Camera2D.global_position + Vector2(1024,-64)
	if not $Fox/VisibleOnScreenNotifier2D.is_on_screen():
		print ("Creating new fox...")
	 
		$Fox.position = (enemyLocation)
		print ("Spawned at ")
		print (enemyLocation)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$Fox.stillLoading = true
	$FoxTimer.start(2)
