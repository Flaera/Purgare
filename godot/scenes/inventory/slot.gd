extends Control



@onready var prev_pos


func add_item(add_texture, add_amount):
	var slots = get_parent().get_children()
	for slot in slots:
		if (slot.get_node("SpriteItem").texture==null):
			slot.get_node("SpriteItem").texture=add_texture
			slot.get_node("Label").text=str(add_amount)
			return true
		if (slot.get_node("SpriteItem").texture==add_texture):
			var curr_amount: int = int(slot.get_node("Label").text)
			curr_amount+=add_amount
			slot.get_node("Label").text=str(curr_amount)
			return true
	return false


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
