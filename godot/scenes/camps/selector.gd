extends CharacterBody3D

const LIMIT_SCREEN = 1600
@onready var speed: float = 200
@onready var input: Vector2 = Vector2.ZERO
@onready var res_build1 = preload("res://scenes/buildings/ResidentialBuilding1.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("left"):
		input[1] = 1
	if Input.is_action_just_pressed("right"):
		input[1] = -1
	if Input.is_action_just_pressed("up"):
		input[0] = -1
	if Input.is_action_just_pressed("down"):
		input[0] = 1
	
	position.x = clamp(position.x,-LIMIT_SCREEN,LIMIT_SCREEN)
	position.z = clamp(position.z,-LIMIT_SCREEN,LIMIT_SCREEN)
	
	print("pos=",position)
	position.x += input.x*speed
	position.z += input.y*speed
	input = Vector2.ZERO
	#move_and_slide()
	#velocity = Vector3.ZERO
	


func _on_texture_button_pressed():
	var area_bodies: Array[Node3D] = get_node("AreaDetectorBuilds").get_overlapping_bodies()
	var lenght: int = len(area_bodies)
	if (lenght<2 or (lenght==2 and abs(position.x)==abs(position.z))):
		print("CAstou!")
		var build = res_build1.instantiate()
		var mother_builds = get_parent().get_node("Builds")
		mother_builds.add_child(build)
		mother_builds.get_children()[mother_builds.get_child_count()-1].target_pos = position
