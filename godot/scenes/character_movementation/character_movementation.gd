extends CharacterBody3D

const LIMIT = 4.0
var speed = 5
const JUMP_VELOCITY = 4.5
const RAY_LENGTH = 1000.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var cam_rotation = 0.0

@onready var trigger_pos: Vector3 = position
@onready var cam = get_node("Camera3D")
@onready var finished_steps: bool = false
@onready var flag_mouse_in_inventory: bool = false
@onready var money_amount: float = 0.0
@onready var money_lab: Label = get_parent().get_node("CanvasLayer/Control/money_label")
@onready var smooth_anim: float = 0.0
#@export var fish_lab: Label
#@export var farming_lab: Label

@export var steps_sfx: AudioStreamPlayer3D

#var fish_amount = 0.0
#var farming_amount = 0.0



func _ready():
	get_node("Camera3D").current=true
	steps_sfx.playing = false
	MusicController.play_music_and_sfx()
	#get_parent().get_node("interação/ SK_Character_Mother_with_animation/AnimationPlayer").play("idle_animation")
	get_node("AnimationPlayer").play("Dwarf_idle")



func move_to_point(delta):
	var target_pos = get_node("NavigationAgent3D").get_next_path_position()
	var direction = global_position.direction_to(target_pos)
	var node_path = "SKEL_Character_City"
	get_node(node_path).rotation.y = lerp(get_node(node_path).rotation.y,atan2(direction.x, direction.z), delta*15)
	velocity = direction*speed
	#get_node("Mesh").look_at(target_pos,Vector3.UP,true)
	move_and_slide()
	velocity = Vector3.ZERO
	return direction
	


func _physics_process(_delta):
	if (Input.is_action_just_pressed("mouse_click")):
		#print("Acionado")
		var mouse_pos = get_viewport().get_mouse_position()
		var from = cam.project_ray_origin(mouse_pos)
		var to = from + cam.project_ray_normal(mouse_pos) * RAY_LENGTH
		var space = get_world_3d().direct_space_state
		var ray_query = PhysicsRayQueryParameters3D.new()
		ray_query.from = from
		ray_query.to = to
		ray_query.collide_with_areas=true
		ray_query.collide_with_bodies=true
		var result = space.intersect_ray(ray_query)
		#print(result)
		if (result!={}):
			get_node("NavigationAgent3D").target_position = result.position
	var blend_factor = 15
	var parameter_path = "parameters/Blend2/blend_amount"
	if (get_node("NavigationAgent3D").is_navigation_finished()):
		play_steps(false)
		#get_node("AnimationPlayer").play("Dwarf_idle")
		smooth_anim = lerp(smooth_anim, 0.0, _delta*blend_factor)
		print("STOP",smooth_anim)
		#if (smooth_anim.x<0.0):smooth_anim.x=1.0
		get_node("AnimationTree").set(parameter_path,abs(smooth_anim))
		return
	if (flag_mouse_in_inventory==false):
		play_steps(true)
		var vector_pre = move_to_point(_delta)
		smooth_anim = lerp(smooth_anim,vector_pre.x+vector_pre.z,_delta*blend_factor)
		print("GO",vector_pre)
		#if (smooth_anim.x<0.0):smooth_anim.x=1.0
		get_node("AnimationTree").set(parameter_path,abs(smooth_anim))
		



func play_steps(flag_play:bool):
	"""if (flag_play==true and finished_steps==true):
		steps_sfx.playing=flag_play
		flag_play=false
		finished_steps=false"""
	if !flag_play: steps_sfx.play() 
	


func _process(delta):
	if Input.is_action_just_released("scroll_down"):
		cam.size += 1
	if Input.is_action_just_released("scroll_up"):
		cam.size -= 1
	if Input.is_action_just_pressed("cam_right"):
		cam_rotation += 1.5707
	if Input.is_action_just_pressed("cam_left"):
		cam_rotation -= 1.5707
	
	rotation.y = lerp(rotation.y, cam_rotation, delta * 2)
	cam.size = clamp(cam.size, 2, 25)
	
	if cam_rotation > 4 or cam_rotation < -4:
		cam_rotation = 0.0
	
	money_lab.text = str(money_amount)
	#if (!is_on_floor()):
	#	velocity.y-=speed*delta
		
	#if (velocity[0]>0.0 and velocity[2]>0.0):
		#velocity = (trigger_pos - position).normalized()*speed*delta*4
		#play_steps(true)
	#else:
		#velocity = Vector3.ZERO
		#play_steps(false)
		#$Dwarf_Walk_mixamo_com_New/AnimationPlayer.pause("Dwarf_Walk_mixamo_com_New")
	#move_and_slide()
	#position.y = clamp(position.y, 0, LIMIT)


"""func get_pos(event, position):
	if event is InputEventMouse:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			trigger_pos = position
			get_node("Mesh").look_at(position, Vector3.UP, true)



func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	#print("AQUI=")
	get_pos(event, position)"""



"""func fishing_click(camera, event, position, normal, shape_idx):
	if event is InputEventMouse:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			fish_amount += 2.0
			fish_lab.text = (str)(fish_amount)


func farming_click(camera, event, position, normal, shape_idx):
	if event is InputEventMouse:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			farming_amount += 1.0
			farming_lab.text = (str)(farming_amount)
"""



func _on_texture_button_pressed():
	var node_inventory = get_parent().get_node("CanvasLayer/ControlInventory/Inventory")
	node_inventory.visible = !node_inventory.visible



func _on_money_area_input_event(camera, event, position, normal, shape_idx):
	#print("input event")
	if event is InputEventMouse:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			var inventory = get_parent().get_node("CanvasLayer/ControlInventory/Inventory")
			for slot in inventory.get_children():
				if (slot.get_node("SpriteItem").texture!=null):
					pass#print("tex=",slot.get_node("SpriteItem"))


func _on_inventory_visibility_changed():
	flag_mouse_in_inventory=!flag_mouse_in_inventory
