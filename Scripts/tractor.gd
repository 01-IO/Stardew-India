extends CharacterBody2D

@onready var gpu_particles_2d = $GPUParticles2D



#var player_pos = player.get_position()
var on_tractor : bool

const SPEED = 25
var current_dir = "none"


func _physics_process(delta):
	tractor_movement(delta)
	
func tractor_movement(delta):
	gpu_particles_2d.emitting = false
	if Input.is_action_pressed("Right"):
		current_dir = "right"
		play_anim(1)
		
		velocity.x = SPEED
		velocity.y = 0
		
		gpu_particles_2d.emitting = true
		
	elif Input.is_action_pressed("Left"):
		current_dir = "left"
		play_anim(1)
		
		velocity.x = -SPEED
		velocity.y = 0
		
		gpu_particles_2d.emitting = true
		
	elif Input.is_action_pressed("Up"):
		current_dir = "up"
		play_anim(1)
		
		velocity.x = 0
		velocity.y = -SPEED
		
		gpu_particles_2d.emitting = true
		
	elif Input.is_action_pressed("Down"):
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


func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("tractor_side")
		elif movement == 0:
			anim.play("Idle_side")
	
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("tractor_side")
		elif movement == 0:
			anim.play("Idle_side")
	
	if dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("tractor_up")
		elif movement == 0:
			anim.play("Idle_up")
	
	if dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("tractor_down")
		elif movement == 0:
			anim.play("Idle_down")
