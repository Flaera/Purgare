extends Node2D



func play_music_and_sfx():
	get_node("ambient_sfx").playing=true
	get_node("background_sfx").playing=true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
