extends Node2D

@onready var levels = [1,2,3]
@onready var curLevel = 1
var cur_level_instance = ""


# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	var level1 = load("res://Scenes/Level1.tscn")
	cur_level_instance = level1.instantiate()
	var nextLevel = cur_level_instance.get_node("ToNext")
	
	nextLevel.connect("next_level",next_level)
	add_child(cur_level_instance)	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Level manager
	if curLevel == 1:
		pass
	elif curLevel == 2:
		pass
	elif curLevel == 3:
		pass

func changeLevels() -> void:
	print ("Changing to next level...")
	var nextLevel = ""
	var nextLevel_inst = ""
	var ToNextEP = ""
	
	if curLevel == 1:
		curLevel = 2
		nextLevel = load("res://Scenes/level2.tscn")
		cur_level_instance.queue_free()
		nextLevel_inst = nextLevel.instantiate()
		ToNextEP = nextLevel_inst.get_node("ToNext")
		ToNextEP.connect("next_level",next_level)
		
		
	elif curLevel == 2:
		curLevel = 3
		nextLevel = load("res://Scenes/level3.tscn")
		cur_level_instance.queue_free()
		nextLevel_inst = nextLevel.instantiate()
		
	
	cur_level_instance = nextLevel_inst
	add_child(nextLevel_inst)
	
	

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

	pass # Replace with function body.
