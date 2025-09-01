extends Node2D

enum MUSIC {LEVEL1,LEVEL2,LEVEL3,TITLE,ENDING,GAMEOVER}
enum SPLASH {LEVEL1,LEVEL2,LEVEL3,TITLE,END1, END2, END3, END4, END5, END6,GAMEOVER}
enum LEVEL {TITLE,LEVEL1,LEVEL2,LEVEL3,END1, END2, END3, END4, END5, END6}

const PAUSE_BETWEEN_LEVEL = 3
const PAUSE_BETWEEN_ENDING = 5
const TURTLE_HEALTH = 3

@onready var curLevel : LEVEL = LEVEL.TITLE
@onready var health = TURTLE_HEALTH
var cur_level_instance = ""
var cur_music = ""


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
	var timerPause = PAUSE_BETWEEN_LEVEL

	if toSplash >= SPLASH.END1:
		timerPause = PAUSE_BETWEEN_ENDING

	match toSplash:
		SPLASH.LEVEL1:
			splashScreen = load("res://Scenes/level1_intro.tscn")
		SPLASH.LEVEL2:
			splashScreen = load("res://Scenes/level2_intro.tscn")
		SPLASH.LEVEL3:
			splashScreen = load("res://Scenes/Level3_intro.tscn")
		SPLASH.END1:
			splashScreen = load("res://Scenes/end_1.tscn")
		SPLASH.END2:
			splashScreen = load("res://Scenes/end_2.tscn")
		SPLASH.END3:
			splashScreen = load("res://Scenes/end_3.tscn")
		SPLASH.END4:
			splashScreen = load("res://Scenes/end_4.tscn")
		SPLASH.END5:
			splashScreen = load("res://Scenes/end_5.tscn")
		SPLASH.END6:
			splashScreen = load("res://Scenes/end_6.tscn")

	$Life.hide()
	splashInstance = splashScreen.instantiate()
	if is_instance_valid(cur_level_instance):
		print ("Freeing " + cur_level_instance.name + "...")
		cur_level_instance.queue_free()
	cur_level_instance = splashInstance
	add_child(splashInstance)
	$SplashTimer.start(timerPause)

func changeLevels() -> void:
	print ("Changing to next level...")
	var nextLevel = ""
	var nextLevel_inst = ""
	var nextMusic = ""
	var nextMusicInst = ""
	var ToNextEP = ""

	match curLevel:
		LEVEL.LEVEL1:
			call_deferred("changeSplashScreen",SPLASH.LEVEL2)
			call_deferred("changeLevelMusic",MUSIC.LEVEL2)
		LEVEL.LEVEL2:
			call_deferred("changeSplashScreen",SPLASH.LEVEL3)
			call_deferred("changeLevelMusic",MUSIC.LEVEL3)
		LEVEL.LEVEL3:
			call_deferred("changeSplashScreen",SPLASH.END1)
			call_deferred("changeLevelMusic",MUSIC.ENDING)
			pass
		_:
			print ("Unknown level state.  Ending game.")
			queue_free()
	
func changeToLevel(toNextLevel: int) -> void:	
	var nextLevel = ""
	var nextLevel_inst = ""
	var ToNextEP = ""
	match toNextLevel:
		LEVEL.LEVEL1:
			curLevel = LEVEL.LEVEL1
			nextLevel = load("res://Scenes/Level1.tscn")
			nextLevel_inst = nextLevel.instantiate()
			var nextLevelPoint = nextLevel_inst.get_node("ToNext")
			var player = nextLevel_inst.get_node("Turtle")
			var killzone = nextLevel_inst.get_node("KillZone")

			nextLevelPoint.connect("next_level",changeLevels)
			player.connect("took_damage", took_damage)
			killzone.connect("kill_player", took_damage)
		LEVEL.LEVEL2:
			curLevel = LEVEL.LEVEL2
			nextLevel = load("res://Scenes/level2.tscn")
			cur_level_instance.queue_free()
			nextLevel_inst = nextLevel.instantiate()
			ToNextEP = nextLevel_inst.get_node("ToNext")
			ToNextEP.connect("next_level",changeLevels)

			var killzone = nextLevel_inst.get_node("KillZone")
			killzone.connect("kill_player", took_damage)

			var player = nextLevel_inst.get_node("Turtle")
			player.connect("took_damage", took_damage)
		LEVEL.LEVEL3:
			curLevel = LEVEL.LEVEL3
			nextLevel = load("res://Scenes/level3.tscn")
			cur_level_instance.queue_free()
			nextLevel_inst = nextLevel.instantiate()
			var rabbit = nextLevel_inst.get_node("Rabbit")
			rabbit.connect("winner", changeLevels)
		_:
			#Probably ending.  Don't set up another level.
			pass

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
		MUSIC.ENDING:
			newMusic = load("res://Scenes/ending_song.tscn")
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
		LEVEL.LEVEL1:
			changeToLevel(LEVEL.LEVEL2)
		LEVEL.LEVEL2:
			changeToLevel(LEVEL.LEVEL3)
		LEVEL.LEVEL3:
			#Time to end the game. Use curLevel to keep track of which one we're on.
			curLevel = LEVEL.END1
			#Call the next splash screen.
			changeSplashScreen(SPLASH.END2)
		LEVEL.END1:
			curLevel = LEVEL.END2
			#Call the next splash screen.
			changeSplashScreen(SPLASH.END3)
		LEVEL.END2:
			curLevel = LEVEL.END3
			#Call the next splash screen.
			changeSplashScreen(SPLASH.END4)
		LEVEL.END3:
			curLevel = LEVEL.END4
			#Call the next splash screen.
			changeSplashScreen(SPLASH.END5)
		LEVEL.END4:
			curLevel = LEVEL.END5
			#Call the next splash screen.
			changeSplashScreen(SPLASH.END6)
		LEVEL.END5:
			curLevel = LEVEL.END6
			#Nothing left to do.
		LEVEL.END6:
			#Figure out what to do after the last wait timer goes off.
			#For now, nothing.
			pass
		_:
			changeToLevel(1)
	if curLevel < LEVEL.END1:
		$Life.show()

func _on_life_game_over() -> void:
	#Load our game over scene, and quit the current one.
	$Life.queue_free()
	cur_level_instance.queue_free()
	cur_music.queue_free()
	var game_over_scene = load("res://Scenes/GameOver.tscn").instantiate()
	add_child(game_over_scene)
