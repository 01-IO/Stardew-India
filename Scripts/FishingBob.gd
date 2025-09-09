extends CharacterBody2D

@onready var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var drag : float = ProjectSettings.get_setting("physics/2d/default_linear_damp")

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity = velocity * clampf(1.0 - drag * delta, 0, 1)
	move_and_slide()
	#var collision = move_and_collide(velocity * delta)


"""For stopping the ball MAKE IT STOP WHERE THE LINE ENDS"""
