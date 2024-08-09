extends Node3D



@export var texture: Texture2D
@export var amount: int = 1


func _on_area_3d_body_entered(body):
	if (body.name == "Char"):
		get_parent().get_parent().get_node("CanvasLayer/ControlInventory/Inventory/GridContainer/Slot").add_item(texture,amount)
		queue_free()
