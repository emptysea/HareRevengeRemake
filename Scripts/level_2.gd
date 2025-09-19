extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BirdTimer.start(2)
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#We need to check and see if we should swoop the bird.
	var birdx = $Bird.position.x
	var birdy = $Bird.position.y
	var turtlex = $Turtle.position.x
	var turtley = $Turtle.position.y
	
	var deltay = turtley - birdy
	var deltax = turtlex - birdx
	
	var slope = abs(deltay/deltax)
	
	if birdy > -105 and birdy < -99:
		$Bird.change_pattern(0)
	elif slope > .8 and slope < .9:
		print ("Time to swoop!")
		$Bird.change_pattern(1)

func _on_bird_timer_timeout() -> void:
	#Create our bird	
	var screensize = get_viewport_rect().size
	var screencenterX = $Turtle/Camera2D.get_screen_center_position().x	
	var enemyLocationX = screencenterX + (screensize.x/2) + 32
	var enemyLocationY = $Turtle/Camera2D.global_position.y - randi_range(0, 4) * 64
	var enemyLocation = Vector2(enemyLocationX,enemyLocationY)
		
	if not $Bird/VisibleOnScreenNotifier2D.is_on_screen(): 
		
		
		$Bird.position = (enemyLocation)
		$Bird.visible = true
		$Bird.collision_layer = 4
		$Bird.change_pattern(0)
		print ("Spawned at " + str(enemyLocation))
		print ("viewport size " + str(get_viewport_rect().size))
		print ("Turtle at" + str($Turtle.global_position))
		print ("Camera at" + str($Turtle/Camera2D.global_position))
		print ("Camera center " + str($Turtle/Camera2D.get_screen_center_position()))


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$BirdTimer.start(2)
