extends Node3D


@onready var max_timer_mensage: float = 7.0
@onready var timer_view_mensage: float = max_timer_mensage
@onready var texture0: Texture2D = preload("res://assets/dialogs/dialog_shoper/balon_1.png")
@onready var texture1: Texture2D = preload("res://assets/dialogs/dialog_shoper/balon_2.png")
@onready var texture2: Texture2D = preload("res://assets/dialogs/dialog_shoper/balon_3.png")
@onready var texture3: Texture2D = preload("res://assets/dialogs/dialog_shoper/balon_4.png")
@onready var state_dialog: int = 0
#@onready var one_time: bool = true


@export var texture_carrot: Texture2D
#@export var texture0: Texture2D
#@export var texture1: Texture2D
#@export var texture2: Texture2D
#@export var texture3: Texture2D
@export var amount_money_by_item: int

func change_tex(tex: Texture2D):
	var node_tex=get_node("MeshInstance3D")
	var mat: StandardMaterial3D = StandardMaterial3D.new()
	mat.albedo_texture = tex
	mat.billboard_mode=BaseMaterial3D.BILLBOARD_ENABLED
	mat.transparency=BaseMaterial3D.TRANSPARENCY_ALPHA
	node_tex.set_surface_override_material(0, mat)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#get_node("MeshInstance3D").look_at(get_parent().get_parent().get_node("Player/Camera3D").position, Vector3.UP, true)
	timer_view_mensage+=delta
	if (timer_view_mensage<max_timer_mensage/2.0):
		if (state_dialog==0):
			#print("AQUI1=",state_dialog)
			change_tex(texture0)
		elif (state_dialog==1):
			#print("AQUI2=",state_dialog)
			change_tex(texture2)
	elif (timer_view_mensage>=max_timer_mensage/2.0):
		if (state_dialog==0):
			change_tex(texture1)
		elif (state_dialog==1):
			change_tex(texture3)
		#print("AQUI")
		#one_time=false
	


func _on_shoper_area_3d_body_entered(body):
	#print("body.name=",body.name)
	var node_inventory = get_parent().get_parent().get_node("CanvasLayer/ControlInventory/Inventory/GridContainer")
	for slot in node_inventory.get_children():
		if (slot.get_node("SpriteItem").texture==texture_carrot):
			#get_parent().get_parent().get_node("Player").money_amount+=amount_money_by_item*int(slot.get_node("Label").text)
			var res = ResourceLoader.load("res://resources/quests.tres")
			if (res.quest_mechanic==1):
				res.quest_mechanic = 2
				ResourceSaver.save(res,"res://resources/quests.tres")
			#slot.get_node("SpriteItem").texture=null
			#slot.get_node("Label").text=""
			state_dialog = 1
			break
	if (body.name=="Player"):
		var res = ResourceLoader.load("res://resources/quests.tres")
		if (res.quest_mechanic<1):
			res.quest_mechanic = 1
			ResourceSaver.save(res,"res://resources/quests.tres")
		timer_view_mensage = 0.0
		var node_mesh = get_node("MeshInstance3D")
		node_mesh.visible=true
		


func _on_shoper_area_3d_body_exited(body):
	if (body.name=="Player"):
		var node_mesh = get_node("MeshInstance3D")
		node_mesh.visible=false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_node("AnimationPlayer").play(anim_name)
