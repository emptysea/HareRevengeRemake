extends Node2D

@onready var levels = [1,2,3]
@onready var curLevel = 1
@onready var health = 3
var cur_level_instance = ""
var cur_music = ""


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var level1 = load("res://Scenes/Level1.tscn")
	var level1_music = load("res://Scenes/level_1_music.tscn")
	cur_level_instance = level1.instantiate()
	cur_music = level1_music.instantiate()
	var nextLevel = cur_level_instance.get_node("ToNext")
	var player = cur_level_instance.get_node("Turtle")
	var killzone = cur_level_instance.get_node("KillZone")
	
	nextLevel.connect("next_level",changeLevels)
	player.connect("took_damage", took_damage)
	killzone.connect("kill_player", took_damage)
	add_child(cur_level_instance)
	add_child(cur_music)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func changeLevels() -> void:
	print ("Changing to next level...")
	var nextLevel = ""
	var nextLevel_inst = ""
	var nextMusic = ""
	var nextMusicInst = ""
	var ToNextEP = ""
	
	match curLevel:
		1:
			curLevel = 2
			nextLevel = load("res://Scenes/level2.tscn")
			nextMusic = load("res://Scenes/Level2_music.tscn")
			cur_level_instance.queue_free()
			cur_music.queue_free()
			nextLevel_inst = nextLevel.instantiate()
			nextMusicInst = nextMusic.instantiate()
			ToNextEP = nextLevel_inst.get_node("ToNext")
			ToNextEP.connect("next_level",changeLevels)
			
			var killzone = nextLevel_inst.get_node("KillZone")
			killzone.connect("kill_player", took_damage)
		2:
			curLevel = 3
			nextLevel = load("res://Scenes/level3.tscn")
			nextMusic = load("res://Scenes/Level3_music.tscn")
			cur_level_instance.queue_free()
			cur_music.queue_free()
			nextLevel_inst = nextLevel.instantiate()
			nextMusicInst = nextMusic.instantiate()
		3:
			pass
		_:
			print ("Unknown level state.  Ending game.")
			queue_free()

	var player = nextLevel_inst.get_node("Turtle")
	player.connect("took_damage", took_damage)
	cur_level_instance = nextLevel_inst
	cur_music = nextMusicInst
	call_deferred("add_child",nextLevel_inst)
	call_deferred("add_child",nextMusicInst)

func took_damage(damage: int) -> void:
	print ("Damage to take = " + str(damage))
	$Life.take_damage(damage)
	pass

func _on_life_game_over() -> void:
	#Load our game over scene, and quit the current one.
	$Life.queue_free()
	cur_level_instance.queue_free()
	cur_music.queue_free()
	var game_over_scene = load("res://Scenes/GameOver.tscn").instantiate()
	add_child(game_over_scene)
	
func changeToLevel(toNextLevel: int) -> void:	
	match toNextLevel:
		1:
			curLevel = 1
			var level1 = load("res://Scenes/Level1.tscn")
			cur_level_instance = level1.instantiate()
			
			var nextLevel = cur_level_instance.get_node("ToNext")
			var player = cur_level_instance.get_node("Turtle")
			var killzone = cur_level_instance.get_node("KillZone")
	
			nextLevel.connect("next_level",changeLevels)
			player.connect("took_damage", took_damage)
			killzone.connect("kill_player", took_damage)
			add_child(cur_level_instance)
		2:
			pass
		3:
			pass	
