extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _process(delta):
	#print(Stopwatch.get_time())
	$CanvasLayer/Control/Label.text = Stopwatch.get_time()
	#$CanvasLayer/Control/Label2.text = CarSUV.stats()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area_body_entered(body):
	if body.is_in_group("PlayerCar"):
		Stopwatch.game_start()
