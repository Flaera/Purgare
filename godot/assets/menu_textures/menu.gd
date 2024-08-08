extends Control


@onready var pksc: PackedScene = preload("res://scenes/character_movementation/world.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	MusicController.play_music_and_sfx()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_btn_settings_pressed():
	get_tree().change_scene_to_packed(pksc)
