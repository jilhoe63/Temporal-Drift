extends Node

onready var game_start_time = OS.get_ticks_msec()
var current_spawn = null
var timer_start = false
var stop_time = "00:00:00"

func game_start():
	game_start_time = OS.get_ticks_msec()
	timer_start = true

func get_time():
	if timer_start:
		var current_time = OS.get_ticks_msec() - game_start_time
		var minutes = current_time/1000/60
		var seconds = current_time/1000%60
		var milliseconds = current_time%1000/10
		if minutes < 10:
				minutes = "0"+str(minutes)
		if seconds < 10:
				seconds = "0"+str(seconds)
		if milliseconds < 10:
			if milliseconds == 0:
				milliseconds = "00"
			else:
				milliseconds = "0" + str(milliseconds)
		return str(minutes)+":"+str(seconds)+":"+str(milliseconds)
	else:
		return stop_time

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
