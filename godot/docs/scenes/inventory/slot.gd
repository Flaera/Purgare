extends Control



@onready var prev_pos



func _get_drag_data(at_position):
	var data: Dictionary ={
		"sprite_tex":get_node("SpriteItem").texture,
		"amount":get_node("Label").text,
		"backup":self
	}
	
	var preview = self.duplicate()
	
	get_node("SpriteItem").texture=null
	get_node("Label").text=""
	
	preview.get_node("BG").visible=false
	preview.get_node("Label").visible=false
	preview.get_node("SpriteItem").position = -preview.size/2
	set_drag_preview(preview)
	
	return data


func _can_drop_data(at_position, data):
	return true
	
func _drop_data(at_position, data):
	print("data=",data)
	if (get_node("SpriteItem").texture==data.sprite_tex):
		var drop_item: int = int(get_node("Label").text)
		drop_item+=int(data.amount)
		get_node("Label").text = str(drop_item)
	else:
		data.backup.get_node("SpriteItem").texture=get_node("SpriteItem").texture
		data.backup.get_node("Label").text=get_node("Label").text
		
		get_node("SpriteItem").texture=data.sprite_tex
		get_node("Label").text=data.amount
