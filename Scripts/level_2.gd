extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BirdTimer.start(2)
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_bird_timer_timeout() -> void:
	#Create our bird	
	var screensize = get_viewport_rect().size
	var screencenterX = $Turtle/Camera2D.get_screen_center_position().x	
	var enemyLocationX = screencenterX + (screensize.x/2) + 32
	var enemyLocationY = randi_range(0, 5) * 64
	var enemyLocation = Vector2(enemyLocationX,$Turtle/Camera2D.global_position.y - enemyLocationY)
	if not $Bird/VisibleOnScreenNotifier2D.is_on_screen(): 
		$Bird.position = (enemyLocation)
		$Bird.visible = true
		$Bird.collision_layer = 4
		print ("Spawned at " + str(enemyLocation))
		print ("viewport size " + str(get_viewport_rect().size))
		print ("Turtle at" + str($Turtle.global_position))
		print ("Camera at" + str($Turtle/Camera2D.global_position))
		print ("Camera center " + str($Turtle/Camera2D.get_screen_center_position()))


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$BirdTimer.start(2)
