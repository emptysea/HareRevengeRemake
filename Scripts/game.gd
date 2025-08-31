extends Node2D

@onready var levels = [1,2,3]
@onready var curLevel = 0
@onready var health = 3
var cur_level_instance = ""
var cur_music = ""

enum MUSIC {LEVEL1,LEVEL2,LEVEL3,TITLE,ENDING,GAMEOVER}
enum SPLASH {LEVEL1,LEVEL2,LEVEL3,TITLE,ENDING,GAMEOVER}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	changeSplashScreen(SPLASH.LEVEL1)
	changeLevelMusic(MUSIC.LEVEL1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func changeSplashScreen(toSplash : SPLASH) -> void:
	var splashScreen
	var splashInstance
	match toSplash:
		SPLASH.LEVEL1:
			splashScreen = load("res://Scenes/level1_intro.tscn")
		SPLASH.LEVEL2:
			splashScreen = load("res://Scenes/level2_intro.tscn")
		SPLASH.LEVEL3:
			splashScreen = load("res://Scenes/Level3_intro.tscn")

	$Life.hide()
	splashInstance = splashScreen.instantiate()
	if is_instance_valid(cur_level_instance):
		print ("Freeing " + cur_level_instance.name + "...")
		cur_level_instance.queue_free()
	cur_level_instance = splashInstance
	add_child(splashInstance)
	$SplashTimer.start(3)

func changeLevels() -> void:
	print ("Changing to next level...")
	var nextLevel = ""
	var nextLevel_inst = ""
	var nextMusic = ""
	var nextMusicInst = ""
	var ToNextEP = ""
	
	match curLevel:
		1:
			call_deferred("changeSplashScreen",SPLASH.LEVEL2)
			call_deferred("changeLevelMusic",MUSIC.LEVEL2)
		2:
			call_deferred("changeSplashScreen",SPLASH.LEVEL3)
			call_deferred("changeLevelMusic",MUSIC.LEVEL3)
		_:
			print ("Unknown level state.  Ending game.")
			queue_free()
	
func changeToLevel(toNextLevel: int) -> void:	
	var nextLevel = ""
	var nextLevel_inst = ""
	var ToNextEP = ""
	match toNextLevel:
		1:
			curLevel = 1
			nextLevel = load("res://Scenes/Level1.tscn")
			nextLevel_inst = nextLevel.instantiate()
			var nextLevelPoint = nextLevel_inst.get_node("ToNext")
			var player = nextLevel_inst.get_node("Turtle")
			var killzone = nextLevel_inst.get_node("KillZone")
			
			nextLevelPoint.connect("next_level",changeLevels)
			player.connect("took_damage", took_damage)
			killzone.connect("kill_player", took_damage)
		2:
			curLevel = 2
			nextLevel = load("res://Scenes/level2.tscn")
			cur_level_instance.queue_free()
			nextLevel_inst = nextLevel.instantiate()
			ToNextEP = nextLevel_inst.get_node("ToNext")
			ToNextEP.connect("next_level",changeLevels)
			
			var killzone = nextLevel_inst.get_node("KillZone")
			killzone.connect("kill_player", took_damage)
			
			var player = nextLevel_inst.get_node("Turtle")
			player.connect("took_damage", took_damage)
		3:
			curLevel = 3
			nextLevel = load("res://Scenes/level3.tscn")
			cur_level_instance.queue_free()
			nextLevel_inst = nextLevel.instantiate()
	
	if is_instance_valid(cur_level_instance):
		print("Freeing " + cur_level_instance.name + "...")
		cur_level_instance.queue_free()
	cur_level_instance = nextLevel_inst
	add_child(cur_level_instance)

func changeLevelMusic(toMusic: MUSIC) -> void:
	var newMusic = load("res://Scenes/level_1_music.tscn")
	match toMusic:
		MUSIC.LEVEL1:
			newMusic = load("res://Scenes/level_1_music.tscn")
		MUSIC.LEVEL2:
			newMusic = load("res://Scenes/Level2_music.tscn")
		MUSIC.LEVEL3:
			newMusic = load("res://Scenes/Level3_music.tscn")
	var music_instance = newMusic.instantiate()
	
	if is_instance_valid(cur_music):
		cur_music.queue_free()
	
	cur_music = music_instance
	add_child(music_instance)

func took_damage(damage: int) -> void:
	print ("Damage to take = " + str(damage))
	$Life.take_damage(damage)
	
func _on_splash_timer_timeout() -> void:
	match curLevel:
		1:
			changeToLevel(2)
		2:
			changeToLevel(3)
		_:
			changeToLevel(1)
				
	$Life.show()

func _on_life_game_over() -> void:
	#Load our game over scene, and quit the current one.
	$Life.queue_free()
	cur_level_instance.queue_free()
	cur_music.queue_free()
	var game_over_scene = load("res://Scenes/GameOver.tscn").instantiate()
	add_child(game_over_scene)
