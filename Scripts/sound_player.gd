extends Node
onready var cheat_code = []
onready var music = AudioStreamPlayer.new()

#This creates dictionary for music track sounds.
var music_tracks = {
	"menu_theme":"res://Music & SFX/Menu .wav",
	"main_theme":"res://Music & SFX/Hot Rod Hot.wav",
	}

#This creates a dictionary for sound effects.
var sound_effects = {
	"accelerate":"res://Music & SFX/Accelerate_revised_2.wav",
	"steer_left":"res://Music & SFX/to_the_left.wav",
	"steer_right":"res://Music & SFX/silence.wav",
	"lift_off":"res://Music & SFX/lift_off.wav",
}

#This checks the inputs for cheatcodes that change the sound effects.
func _unhandled_key_input(event):
	if event.pressed:
		cheat_code.append(event.scancode)
		print(cheat_code.slice(-3,-1))
		if cheat_code.slice(-8,-1) == [73,76,79,86,69,89,79,85]:
			sound_effects.accelerate = "res://Music & SFX/meme_revised.mp3"
		if cheat_code.slice(-5,-1) == [83,72,82,69,75]:
			sound_effects.accelerate = "res://Music & SFX/Shrek Argues with Obi-Wan on Mustafar.wav"
		if cheat_code.slice(-3,-1) == [80,69,84]:
			music.stream = load("res://Music & SFX/WonderPets.wav")
#Volume
var music_db = 1
var sound_db = 1

func change_music_db(val):
	music_db = linear2db(val)

func change_sound_db(val):
	sound_db = linear2db(val)
	
#This plays the music.
func _ready():
	music.stream = load(music_tracks["main_theme"])
	change_music_db(.6)
	add_child(music)
	music.volume_db = music_db
	music.play()
	print(music.stream)
	print("playing music")

#This plays sound effects.
func play_sound_effect(sfx):
	var sound = AudioStreamPlayer.new()
	sound.stream = load(sound_effects[sfx])
	add_child(sound)
	sound.play()
	return sound
	#yield(sound,"finished")
	#sound.queue_free()
	
