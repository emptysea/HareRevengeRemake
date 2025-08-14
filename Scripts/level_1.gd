extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	$FoxTimer.start(2)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var distance : int = abs($Turtle.position.x - $Fox.position.x)
	var turtleIsLeftOfFox : bool
	if $Turtle.position.x > $Fox.position.x:
		turtleIsLeftOfFox = false
	else:
		turtleIsLeftOfFox = true
		
	if distance >= 256:
		if $Fox.movingRight and turtleIsLeftOfFox:
			$Fox.switch_direction()
		elif not $Fox.movingRight and not turtleIsLeftOfFox:
			$Fox.switch_direction()

func _on_fox_timer_timeout() -> void:
	#Create our first fox
	#TODO: Programmatically find the bounds of the level, in case we want to change resolutions.
	var screensize = get_viewport_rect().size
	var screencenterX = $Turtle/Camera2D.get_screen_center_position().x	
	var enemyLocationX = screencenterX + (screensize.x/2) + 64
	var enemyLocation = Vector2(enemyLocationX,$Turtle/Camera2D.global_position.y - 64)
	if not $Fox/VisibleOnScreenNotifier2D.is_on_screen():
		print ("Creating new fox...")
	 
		$Fox.position = (enemyLocation)
		$Fox.visible = true
		print ("Spawned at " + str(enemyLocation))
		print ("viewport size " + str(get_viewport_rect().size))
		print ("Turtle at" + str($Turtle.global_position))
		print ("Camera at" + str($Turtle/Camera2D.global_position))
		print ("Camera center " + str($Turtle/Camera2D.get_screen_center_position()))


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$Fox.visible = false
	$Fox.stillLoading = true
	$FoxTimer.start(2)
