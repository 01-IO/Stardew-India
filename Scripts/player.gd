extends CharacterBody2D

@onready var gpu_particles_2d = $GPUParticles2D
@onready var shock = $Shock
@onready var fishing_rod = $FishingRod

#@export var EXPLOSION_FORCE: float = 300.0
const SPEED = 100
var current_dir = "none"

const PROJECTILE = preload("res://Scenes/Bob.tscn")

func _physics_process(delta): 
	player_movement(delta)




#func fisher():
	#var random = randi() % 5
	#var icon : bool = false
	#if Input.is_action_just_pressed("Interact"):
		#if random > 2:
			#await get_tree().create_timer(4.0).timeout
			#icon = true
			#shock.visible = true
			#
		#elif random<2:
			#await get_tree().create_timer(2.0).timeout
			#icon = true
			#shock.visible = true
	#if Input.is_action_just_pressed("Enter"):
		#icon = false
		#shock.visible = false
		
func player_movement(delta):
	gpu_particles_2d.emitting = false
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		
		velocity.x = SPEED
		velocity.y = 0
		
		gpu_particles_2d.emitting = true
		
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		
		velocity.x = -SPEED
		velocity.y = 0
		
		gpu_particles_2d.emitting = true
		
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1)
		
		velocity.x = 0
		velocity.y = -SPEED
		
		gpu_particles_2d.emitting = true
		
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		
		velocity.x = 0
		velocity.y = SPEED
		
		gpu_particles_2d.emitting = true
		
	else:
		velocity.x = 0
		velocity.y = 0
		play_anim(0)
		
		gpu_particles_2d.emitting = false
	
	move_and_slide()


func play_anim(movement: int) -> void:
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		fishing_rod.flip_h = false
		if movement == 1:
			anim.play("Run_sideways")
		elif movement == 0:
			anim.play("Idle_sideways")
	
	if dir == "left":
		anim.flip_h = true
		fishing_rod.flip_h = true
		if movement == 1:
			anim.play("Run_sideways")
		elif movement == 0:
			anim.play("Idle_sideways")
	
	if dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("Run_up")
		elif movement == 0:
			anim.play("Idle_up")
	
	if dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("Run_down")
		elif movement == 0:
			anim.play("Idle")
