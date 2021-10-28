extends Node
onready var cheat_code = []
onready var music = AudioStreamPlayer.new()

var music_tracks = {
	"menu_theme":"res://Music & SFX/Menu .wav",
	"main_theme":"res://Music & SFX/Hot Rod Hot.wav",
	}

var sound_effects = {
	"accelerate":"res://Music & SFX/revised_acceleration.wav",
	"steer_left":"res://Music & SFX/to_the_left.wav",
	"steer_right":"res://Music & SFX/silence.wav",
}

func _unhandled_key_input(event):
	if event.pressed:
		cheat_code.append(event.scancode)
		print(cheat_code.slice(-8,-1))
		if cheat_code.slice(-8,-1) == [73,76,79,86,69,89,79,85]:
			sound_effects.accelerate = "res://Music & SFX/meme_revised.mp3"
		if cheat_code.slice(-5,-1) == [83,72,82,69,75]:
			sound_effects.accelerate = "res://Music & SFX/Shrek Argues with Obi-Wan on Mustafar.wav"
		if cheat_code.slice(-2,-1) == [76,79,76]:
			sound_effects.steer_left = "res://Music & SFX/to_the_left.wav"
			sound_effects.steer_right = "res://Music & SFX/to_the_right.wav"

var music_db = 1
var sound_db = 1

func change_music_db(val):
	music_db = linear2db(val)

func change_sound_db(val):
	sound_db = linear2db(val)
	
func _ready():
	music.stream = load(music_tracks["main_theme"])
	add_child(music)
	#music.play()
	print(music.stream)
	print("playing music")

func play_sound_effect(sfx):
	var sound = AudioStreamPlayer.new()
	sound.stream = load(sound_effects[sfx])
	add_child(sound)
	sound.play()
	return sound
	#yield(sound,"finished")
	#sound.queue_free()
	
