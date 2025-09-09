extends CharacterBody2D

const hSPEED = 70
const vSPEED = 40

var state : int = 0 #0:idle 1:right 2:left 3:up 4:down

var is_finished : bool 

var movement_speed: float = 40
var movement_target_position: Vector2 = Vector2(197.0,328.0)
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
#@onready var world = $World
#var bob_global = world.bob.global_position
@export var fishing_bob : Area2D

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	
	
	
	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movement_target_position)
	
func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(delta):
	
	#print(navigation_agent.is_navigation_finished())
	if navigation_agent.is_navigation_finished() == true:
		#if state == 0:
			#pass
		if state == 1: 
			movement_target_position = Vector2(-266.0, 384.0)
			set_movement_target(movement_target_position)
		elif state == 2: 
			movement_target_position = Vector2(197.0,328.0)
			set_movement_target(movement_target_position)
		elif state == 3: 
			movement_target_position = Vector2(176.0,385.0)
			set_movement_target(movement_target_position)
		elif state == 4:
			movement_target_position = Vector2(-304.0, 326.0)
			set_movement_target(movement_target_position)
		#elif global_position == bob_global:
			#print("Actor Entered")
			#set_movement_target(bob_global)
			#return
		state = (randi_range(0,4))
		print(state)
	if navigation_agent.is_navigation_finished() == false:
		pass
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()
