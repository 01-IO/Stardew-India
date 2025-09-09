extends Node2D

@onready var tile_map = $CowNavRegion/TileMap
@onready var player = $Player
@onready var tractor = $Tractor
@onready var button = $Button
@onready var fishing_rod = $Player/FishingRod

@onready var tractor_pos : Vector2 = tractor.position

@onready var line_2d = $Player/FishingRod/Line2D
@onready var limiter_1 = $"Player/FishingRod/Limiter 1"
@onready var limiter_2 = $"Player/FishingRod/Limiter 2"
@onready var limiter_3 = $"Player/FishingRod/Limiter 3"
@onready var line_emitter = $"Player/FishingRod/Line Emitter"
@onready var bob = $Player/FishingRod/Bob

@onready var fishy_movement = $FishyMovement

@onready var cow = $Cow
@onready var cow_2 = $Cow2

signal cow_in_area(value)
#var cow_arr_name = [cow.name, cow_2.name]
#@onready var milk_amount = $"Player/Camera2D/Milk Amount"
#@onready var cattle_food = $Player/Camera2D/CattleFood
#@onready var coin_amount = $"Player/Camera2D/Coin Amount"

const PROJECTILE = preload("res://Scenes/Bob.tscn")

var old_player_pos : Vector2

var ground_layer = 1
var environment_layer = 2

var can_place_seed_custom_data = "can_place_seeds"
var can_place_dirt_custom_data = "can_place_dirt"
var is_crop = "is_crop"
var is_fishing : bool = false

enum FARMING_MODES {SEEDS, DIRT, FISHING, NOTHING}
var farming_mode_state = FARMING_MODES.DIRT

var dirt_tiles = []

var cow_in_region : bool = false
var cows_in_fence : Array = []


const SPEED = 40


func _ready():
	pass
	
func _process(delta):
	exit_tractor(old_player_pos)
	
	var mouse_pos : Vector2 = get_global_mouse_position()
	
	fishing(mouse_pos, delta)
	#print(bob.position)
	#milk_amount.text = ": " + str(Global.milk_score)
	#cattle_food.text = ": " + str(Global.total_cattle_food)
	#coin_amount.text = ": " + str(Global.gold)
func _physics_process(delta):
	await get_tree().physics_frame
	if fishy_movement.navigation_agent.is_navigation_finished() == false:
		if fishy_movement.global_position == bob.global_position:
			print("entered")
			fishy_movement.navigation_agent.target_position = fishy_movement.global_position
	
	if cow_in_region == false and cow.take_to_vet == false:
		get_node("Cow/AnimatedSprite2D").play("idle")
		

		cow.can_walk = false
		cow.cow_wait(delta)

	if cow_in_region ==  true and $GoBackRegion.position == cow.global_position:
		print("hua anter")
		cow.can_walk = true
		

func _input(_event):
	if Input.is_action_just_pressed("toggle_dirt"):
		farming_mode_state = FARMING_MODES.DIRT
	if Input.is_action_just_pressed("toggle_seed"):
		farming_mode_state = FARMING_MODES.SEEDS
	if Input.is_action_just_pressed("toggle_fishing"):
		farming_mode_state = FARMING_MODES.FISHING
		fishing_rod.visible = true
		is_fishing = true
	if Input.is_action_just_pressed("Click"):
		var mouse_pos : Vector2 = get_global_mouse_position()
		var tile_mouse_pos : Vector2i = tile_map.local_to_map(mouse_pos)

		
		#	var tile_data : TileData = tile_map.get_cell_tile_data(ground_layer, tile_mouse_pos)
		
		if farming_mode_state == FARMING_MODES.SEEDS:
			fishing_rod.visible = false
			var atlas_coord : Vector2i = Vector2i(11,1)
			if check_custom_data(tile_mouse_pos, can_place_seed_custom_data, ground_layer):
				var level = 0
				var final_seed_level = 3
				handle_seed(tile_mouse_pos, level, atlas_coord, final_seed_level)
		
		elif farming_mode_state == FARMING_MODES.DIRT:
			fishing_rod.visible = false
			if check_custom_data(tile_mouse_pos, can_place_dirt_custom_data, ground_layer):
				dirt_tiles.append(tile_mouse_pos)
				tile_map.set_cells_terrain_connect(ground_layer, dirt_tiles, 2, 0)
		
		elif farming_mode_state == FARMING_MODES.FISHING:
			pass

func check_custom_data(mouse_pos, custom_data_layer,layer):
	var tile_data : TileData = tile_map.get_cell_tile_data(layer, mouse_pos)
	if tile_data:
		return tile_data.get_custom_data(custom_data_layer)
	else:
		return false


func handle_seed(tile_map_pos, level, atlas_coord, final_seed_level):
	var source_id = 1 
	tile_map.set_cell(environment_layer, tile_map_pos, source_id, atlas_coord)
	
	await get_tree().create_timer(5.0).timeout
	
	if level == final_seed_level:
		return
	else: 
		var new_atlas : Vector2i = Vector2i(atlas_coord.x + 1, atlas_coord.y)
		tile_map.set_cell(environment_layer, tile_map_pos, source_id, new_atlas)
		handle_seed(tile_map_pos, level + 1, new_atlas, final_seed_level)
		


func _on_button_pressed():
	
	var new_player_pos : Vector2 = tractor_pos
	var new_player_pos_offset = new_player_pos + Vector2(0,10)
	player.set_position(new_player_pos_offset)
	
	await get_tree().create_timer(2.0).timeout
	button.visible = false
	
	#add_child()
	#get_child()

func exit_tractor(old_player_pos):
	if(Input.is_action_just_pressed("Hop_in_out")):
		player.position = old_player_pos

func fishing(mouse_pos, delta):
	var mouse_pos_x : float = mouse_pos.x
	var mouse_pos_y : float = mouse_pos.y
	
	var bob_count : int = 0
	
	var limiter1_pos : Vector2 = limiter_1.position
	var limiter2_pos : Vector2 = limiter_2.position
	var limiter3_pos : Vector2 = limiter_3.position
	
	var bob_position_x = bob.position.x
	var bob_position_y = bob.position.y
	var new_bob_pos : Vector2
		
	if Input.is_action_just_pressed("Click"):
		line_2d.add_point(line_emitter.position, 0)
		if mouse_pos_y > limiter1_pos.y:
			mouse_pos_y = limiter1_pos.y
		elif mouse_pos_x < limiter2_pos.x:
			mouse_pos_x = limiter2_pos.x
		elif mouse_pos_x > limiter3_pos.x:
			mouse_pos_x = limiter3_pos.x
		line_2d.add_point(Vector2(mouse_pos_x, mouse_pos_y), 1)
	
		if bob_count < 1:
			bob.visible = true
			bob.position = Vector2(mouse_pos_x, mouse_pos_y)
			bob_count = bob_count + 1 
	if Input.is_action_just_pressed("RightClick"):
		print("entered")
		line_2d.clear_points()

		bob.visible = false
	
	if Input.is_action_pressed("Up"):
		bob.position.y += -SPEED * delta
		line_2d.set_point_position(1,bob.position)
	elif Input.is_action_pressed("Down"):
		bob.position.y += SPEED * delta 
		line_2d.set_point_position(1,bob.position)
	elif Input.is_action_pressed("Right"):                 
		bob.position.x += SPEED * delta
		line_2d.set_point_position(1,bob.position)
	elif Input.is_action_pressed("Left"):
		bob.position.x += -SPEED * delta
		line_2d.set_point_position(1,bob.position)
	new_bob_pos = bob.position
	
	return(new_bob_pos)

func _on_detection_zone_body_entered(body):
	if body.name == "Player":
		button.visible = true
	old_player_pos = player.position
"""TRY--Delete the collision shape of the tractor and use the area2D for removing the crop"""




func _on_crop_remover_body_entered(body):
	
	if body.name == "Tractor":
		var tile_pos : Vector2 = tractor.position
		var tractor_tile_pos : Vector2i = tile_map.local_to_map(tile_pos)
		var under_tractor_tile_data : TileData = tile_map.get_cell_tile_data(ground_layer, tractor_tile_pos)

		print("Tile pos: ", tile_pos, " Local: ", tractor_tile_pos)
		if check_custom_data(tractor_tile_pos, is_crop, environment_layer):
			tile_map.erase_cell(environment_layer, tractor_tile_pos)
		#dirt_tiles.append(local_tile_pos)
		#tile_map.set_cells_terrain_connect(ground_layer, dirt_tiles, 2, 0)



func _on_bob_body_entered(body):

	if body.name == "FishyMovement":
		#await get_tree().create_timer(1.0).timeout
		fishy_movement.global_position = bob.global_position
		#if fishy_movement.global_position == bob.global_position:
			#fishy_movement.set_movement_target(bob.global_position)

"""set a variable in fish scene about the final state of fish being the position of the bob's position, 
change the variable through the world script"""


func _on_go_back_region_body_entered(body):
	if body.name == "Cow":
		cow_in_region = true
		for i in range(0, len(Global.cows)):
			if Global.cows[i]["Name"] == body.name:
				cows_in_fence.append(body.name)
				print(cows_in_fence)
				emit_signal("cow_in_area",cows_in_fence)


func _on_go_back_region_body_exited(body):
	if body.name == "Cow":
		cow_in_region = false
		for i in range(0, len(Global.cows)):
			if Global.cows[i]["Name"] == body.name:
				cows_in_fence.erase(body.name)
				print(cows_in_fence)
				emit_signal("cow_in_area",cows_in_fence)
