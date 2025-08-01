extends Node2D
@onready var levels = [1,2,3]
@onready var curLevel = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var node2 = $"Levels/Level 2"
	var node3 = $"Levels/Level 3"
	
	disable_collisions_in_node(node2)
	disable_collisions_in_node(node3)
	
	node2.process_mode = Node.PROCESS_MODE_DISABLED
	node2.visible = false
	node3.process_mode = Node.PROCESS_MODE_DISABLED
	node3.visible = false
	
	$"Levels/Level 1/ToNext".connect("next_level",next_level)
	$"Levels/Level 2/ToNext".connect("next_level",next_level)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func changeLevels() -> void:
	var curNode = get_node("Levels/Level 1")
	var nextNode = get_node("Levels/Level 2")
	var playerX = 141
	var playerY = -31
	
	if curLevel == 1:
		curLevel = 2
		curNode = get_node("Levels/Level 1")
		nextNode = get_node("Levels/Level 2")
		playerX = 70
		playerY = -150
	elif curLevel == 2:
		curLevel = 3
		curNode = get_node("Levels/Level 2")
		nextNode = get_node("Levels/Level 3")
		playerX = 70
		playerY = -490
	var vector = Vector2(playerX, playerY)	
	var homeVector = Vector2(0,0)
	
	$Player/Turtle.position = (vector)
	$Player/Turtle/Camera2D.position = homeVector
	curNode.visible = false
	curNode.process_mode =Node.PROCESS_MODE_DISABLED
	disable_collisions_in_node(curNode)
	
	nextNode.visible = true
	nextNode.process_mode = Node.PROCESS_MODE_INHERIT
	enable_collisions_in_node(nextNode)

# Disable all CollisionShape2D nodes inside the instanced scene
func disable_collisions_in_node(root: Node):
	for child in root.get_children():
		if child is TileMapLayer:
			child.collision_enabled = false
		elif child is Area2D:
			child.collision_layer = 0
			child.collision_mask = 0
		elif child.get_child_count() > 0:
			disable_collisions_in_node(child)
			
func enable_collisions_in_node(root: Node):
	for child in root.get_children():
		if child is TileMapLayer:
			child.collision_enabled = true
		elif child is Area2D:
			child.collision_layer = 1
			child.collision_mask = 1
		elif child.get_child_count() > 0:
			disable_collisions_in_node(child)
			
func next_level():
	print ("Triggered!")
	changeLevels();
