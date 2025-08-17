extends Node2D

@onready var levels = [1,2,3]
@onready var curLevel = 1
@onready var health = 3
var cur_level_instance = ""


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var level1 = load("res://Scenes/Level1.tscn")
	cur_level_instance = level1.instantiate()
	var nextLevel = cur_level_instance.get_node("ToNext")
	var player = cur_level_instance.get_node("Turtle")
	
	nextLevel.connect("next_level",next_level)
	player.connect("took_damage", took_damage)
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
	var player = nextLevel_inst.get_node("Turtle")
	player.connect("took_damage", took_damage)
	cur_level_instance = nextLevel_inst
	add_child(nextLevel_inst)

func next_level():
	print ("Triggered!")
	changeLevels();

	pass # Replace with function body.

func took_damage(damage: int) -> void:
	print ("Damage to take = " + str(damage))
	$Life.take_damage(1)
	pass


func _on_life_game_over() -> void:
	#Restart the game.
	print (str(get_tree().get_current_scene().name))
	get_tree().reload_current_scene()
