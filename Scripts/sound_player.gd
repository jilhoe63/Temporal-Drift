extends Node

onready var music = AudioStreamPlayer.new()

var music_db = 1
var sound_db = 1

func change_music_db(val):
	music_db = linear2db(val)

func change_sound_db(val):
	sound_db = linear2db(val)
	
func _ready():
	#music.stream = load(music_tracks["main"])
	add_child(music)
	music.play()
	print(music.stream)
	print("playing music")

func play_sound_effect(sfx):
	var sound = AudioStreamPlayer.new()
	#sound.stream = load(sound_effects[sfx])
	add_child(sound)
	sound.play()
	yield(sound,"finished")
	sound.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
