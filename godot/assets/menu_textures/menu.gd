extends Control


@onready var pksc: PackedScene = preload("res://scenes/character_movementation/world.tscn")



func _ready():
	MusicController.play_menu_music(true)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_btn_settings_pressed():
	get_tree().change_scene_to_packed(pksc)


func _on_tree_exited():
	MusicController.play_menu_music(false)
