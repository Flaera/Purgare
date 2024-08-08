extends Node3D



@onready var texture = preload("res://assets/texture_inventory/inventory_remedy.png")



func _on_area_3d_body_entered(body):
	if (body.name == "Char"):
		get_parent().get_parent().get_node("CanvasLayer/ControlInventory/Inventory/GridContainer/Slot").add_item(texture,1)
		queue_free()
