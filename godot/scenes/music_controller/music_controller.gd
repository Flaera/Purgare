extends Node2D



func play_music_and_sfx():
	get_node("ambient_sfx").playing=true
	get_node("background_sfx").playing=true


func play_menu_music(flag_play: bool):
	if (flag_play==true):
		get_node("menu_music").play()
	else:
		get_node("menu_music").stop()
