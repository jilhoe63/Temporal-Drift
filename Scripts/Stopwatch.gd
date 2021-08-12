extends Node

onready var game_start_time = OS.get_ticks_msec()
var current_spawn = null

func get_time():
	var current_time = OS.get_ticks_msec() - game_start_time
	var minutes = current_time/1000/60
	var seconds = current_time/1000%60
	var milliseconds = current_time%1000/10
	return str(minutes)+":"+str(seconds)+":"+str(milliseconds)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
