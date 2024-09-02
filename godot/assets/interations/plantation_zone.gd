extends Node3D


@onready var amount_seeds: int = 0
@onready var start_bar: bool = false
@onready var in_harvest: bool = false
@onready var scene_carrot: PackedScene = preload("res://assets/texture_inventory/assets_inventory/carrot_pickable.tscn")
@onready var can_planting: bool = true


@export var texture_seed: Texture2D



func remove2seeds():
	#Exclude 2 seeds of inventory:
	var slot_seed = null
	var node_inventory = get_parent().get_parent().get_node("CanvasLayer/ControlInventory/Inventory/GridContainer")
	for slot in node_inventory.get_children():
		if slot.get_node("SpriteItem").texture==texture_seed:
			slot.get_node("Label").text = str(amount_seeds-2)
			return



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var progress_bar = get_node("PlantingWarningControl/VBoxContainer/ProgressBar")
	if (start_bar==true and can_planting==true):
		progress_bar.value+=20*delta
	if (progress_bar.value>=progress_bar.max_value and start_bar==true):
		start_bar=false
		in_harvest=true
		get_node("InterativeMeshInstance3D").visible=false
		get_node("PlantingWarningControl/VBoxContainer").visible=false
		remove2seeds()
		can_planting=false
	
	var progress_bar_harvest = get_node("PlantingWarningControl/HarvestVBoxContainer/ProgressBar")
	if (in_harvest==true):
		get_node("PlantingWarningControl/HarvestVBoxContainer").visible=true
		progress_bar_harvest.value+=20*delta
		get_node("PlatationMeshInstance3D").visible=true
	if (progress_bar_harvest.value>=progress_bar_harvest.max_value):
		get_node("PlantingWarningControl/HarvestVBoxContainer").visible=false
		get_node("PlantingWarningControl/VBoxContainer").visible=false
		in_harvest=false
		var mother = get_parent().get_parent()
		var node_pickables = mother.get_node("items_pickable")
		var inst_scene_carrot = scene_carrot.instantiate()
		node_pickables.add_child(inst_scene_carrot)
		inst_scene_carrot.global_position = get_node("PositionCastPickable").global_position
		#print("pos=",self.global_position)
		get_node("PlatationMeshInstance3D").visible=false
		progress_bar_harvest.value = 0.0
	


func _on_plantation_area_3d_body_entered(body):
	var node_inventory = get_parent().get_parent().get_node("CanvasLayer/ControlInventory/Inventory/GridContainer")
	for slot in node_inventory.get_children():
		if (slot.get_node("SpriteItem").texture==texture_seed):
			amount_seeds=int(slot.get_node("Label").text)
	if (body.name=="Player" and amount_seeds>1):
		start_bar = true
		get_node("PlantingWarningControl/VBoxContainer").visible=true
	elif body.name=="Player" and amount_seeds<=1 and can_planting==true:
		get_node("WarningNoSeeds").visible=true
	if ((body.name=="Player") and (can_planting==true or in_harvest==true)):
		get_node("PlantingWarningControl").visible=!get_node("PlantingWarningControl").visible
		


func _on_plantation_area_3d_body_exited(body):
	if (body.name=="Player"):
		get_node("WarningNoSeeds").visible=false
		start_bar=false
		var progress_bar = get_node("PlantingWarningControl/VBoxContainer/ProgressBar")
		progress_bar.value=0.0
		get_node("PlantingWarningControl").visible=!get_node("PlantingWarningControl").visible
		
