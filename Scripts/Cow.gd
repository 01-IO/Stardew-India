extends CharacterBody2D

var state = "no milk"
var cow_health : float = 100.0
var food_limiter = 30.0

var player_in_area : bool = false
var food_given : bool = false
var producing_milk : bool = false

var take_to_vet : bool = false
var can_walk : bool = true

var not_walking = false
var walking = false
var xdir = 1 #1 = right -1 = left
var ydir = 1 #1 = down -1 = up
var speed = 20
var accel = 50 # change for debugging for faster result

var player_position
var target_position
var moving_vertical_horizontal = 1 #1 = horizontal 2 = vertical

@onready var player = get_parent().get_node("Player")
@onready var navigation_agent_2d = $NavigationAgent2D

@export var target : CharacterBody2D 
@export var cow_region : Area2D

var start_healing : bool = false
var cow_in_vet_area : bool = false
var delta_copy #duplicate variable
var cow_wait_timer_timeout : bool = false
var cow_going_back : bool = false

func _ready():
	print(self.name)
	$VetProgress.visible = false
	
	call_deferred("cow_control_setup")
	call_deferred("cow_control2_setup")
	if state == "no milk":
		$GrowthTimer.start()
	
	$Sick.visible = false
	walking = true
	randomize()
	
	#cow_health = 29 #for debugging r4easons this is set to a value of '29'


func _process(delta):

	if state == "no milk":
		$MilkBottleWoBackground.visible = false
		#$AnimatedSprite2D.flip_h = false
		#$AnimatedSprite2D.play("idle")
		if player_in_area:
			if Input.is_action_just_pressed("Enter") and Global.score["Crop"] != 0 and producing_milk!=true:
				food_given = true
				Global.score["Crop"] -= 15
				producing_milk = true
				$GrowthTimer.start()
	if state == "milk":
		milk_man()
	#print(cow_health)
	if cow_health <= 30.0:
		$Sick.visible = true
	elif cow_health > 70.0 and $Sick.visible == true:
		$Sick.visible = false

	if player_in_area == false and take_to_vet == false and start_healing == false: #cow_going_back
		if can_walk:
			walker()
	
	if start_healing:
		#print("entered")
		#print(cow_health)
		$VetProgress.value = -($HealTime.time_left - $VetProgress.max_value)
		if $VetProgress.value == $VetProgress.max_value:
			$VetProgress.visible = false
			cow_health = 100
			print("Cow healed: ", self.name)
			start_healing = false
	#elif player_in_area:
		#$AnimatedSprite2D.play("idle")

func _physics_process(delta):
	delta_copy = delta
	if player_in_area:
		if Input.is_action_just_pressed("Vet"): #V
				take_to_vet = !take_to_vet

	#set_movement_target(target.global_position)
	if take_to_vet == true:
		take_control(delta)
	
	if take_to_vet == false :
		$"Cow Wait Timer".start()
		print("STARTED")
		if start_healing == true or take_to_vet == true:
			self.velocity = Vector2.ZERO
			navigation_agent_2d.target_position = self.global_position
			print("TIMER STOPPED")
			$"Cow Wait Timer".stop()
		
		else:
			$"Cow Wait Timer".start()
	
	if cow_wait_timer_timeout == true and take_to_vet == false and start_healing == false:
		cow_wait(delta)
		$"Cow Wait Timer".stop()
		print("STOPPED")
		cow_going_back = true
		
	

func _on_pickable_area_body_entered(body):
	if body.name == "Player":
		player_in_area = true

func _on_pickable_area_body_exited(body):
	if body.name == "Player":
		player_in_area = false
		

func _on_growth_timer_timeout():
	if food_given == true:
		if state == "no milk":
			state = "milk"
			food_given = false

func milk_man():

		$MilkBottleWoBackground.visible = true
		
		if player_in_area:
			if Input.is_action_just_pressed("Interact"):
				#food_given = false
				#if Global.total_cattle_food != 0:
				print("cow milked")

				Global.score["Milk"] += 5
				print("total milk: ", Global.score["Milk"])
				$AnimationPlayer.play("DropMilkBottle")
				await  get_tree().create_timer(1.5).timeout
				
				cow_health -= food_limiter
				$AnimationPlayer.play("RESET")
				state = "no milk"
				producing_milk = false

func walker():
	var wait_time = 1
	
	if walking == false:
		var x = randi_range(1,2)
		if x == 1:
			moving_vertical_horizontal = 1
		else:
			moving_vertical_horizontal = 2
	
	if walking == true:
		if moving_vertical_horizontal == 1:
			$AnimatedSprite2D.play("cow_walk_right")
			if xdir == 1:
				$AnimatedSprite2D.flip_h = false
			if xdir == -1:
				#$AnimatedSprite2D.play("cow_walk_right")
				$AnimatedSprite2D.flip_h = true
			self.velocity.x = speed * xdir
			self.velocity.y = 0.0
		
		elif moving_vertical_horizontal == 2:
			if ydir == 1:
				$AnimatedSprite2D.play("cow_walk_down")
			if ydir == -1:
				$AnimatedSprite2D.play("cow_walk_up")
			self.velocity.y = speed * ydir
			self.velocity.x = 0
	if not_walking == true:
		$AnimatedSprite2D.play("idle")
		self.velocity.x = 0
		self.velocity.y = 0
	move_and_slide()


func _on_walk_timer_timeout():
	var x = randi_range(1,2)
	var y = randi_range(1,2)
	var wait_time = randi_range(1,4)
	
	if x > 1.5:
		xdir = 1 # right
	else:
		xdir = -1
	if y > 1.5:
		ydir = 1
	else:
		ydir = -1
	$WalkTimer.wait_time = wait_time
	$WalkTimer.start()
	
func cow_control_setup():
	await get_tree().physics_frame
	if target:
		navigation_agent_2d.target_position = target.global_position

func cow_control2_setup():
	await get_tree().physics_frame
	if cow_region:
		navigation_agent_2d.target_position = cow_region.global_position
func take_control(delta):
	"""code trial 2:"""
	#if target:
		#navigation_agent_2d.target_position = target.global_position
	#if navigation_agent_2d.is_navigation_finished():
		#return
	#
	#var current_agent_position = global_position
	#var next_path_position = navigation_agent_2d.get_next_path_position()
	#move_and_slide()
	#
	#$AnimatedSprite2D.flip_h = false if velocity.x > 0 else true
	#
	"""code trial 1:"""
	var direction = Vector2.ZERO
	
	 #set_movement_target is the same as this line of code
	
	direction = navigation_agent_2d.get_next_path_position() - global_position
	direction = direction.normalized()

	velocity = velocity.lerp(direction * speed, accel * delta)
	
	if navigation_agent_2d.is_navigation_finished():
		$AnimatedSprite2D.play("idle")
		return
		
	
	handle_animation(velocity)

	
	move_and_slide()
	
func _on_agent_timer_timeout():
	navigation_agent_2d.target_position = target.global_position

func handle_animation(velocity):
	$AnimatedSprite2D.play("cow_walk_right")
	if velocity.x > 0.5:
		$AnimatedSprite2D.flip_h = false
	if velocity.x < 0.5:
		$AnimatedSprite2D.flip_h = true

func cow_wait(delta):
	var direction = Vector2.ZERO
	
	navigation_agent_2d.target_position = cow_region.global_position #set_movement_target is the same as this line of code
	
	direction = navigation_agent_2d.get_next_path_position() - global_position
	direction = direction.normalized()

	velocity = velocity.lerp(direction * speed, accel * delta)
	
	if navigation_agent_2d.is_navigation_finished():
		$AnimatedSprite2D.play("idle")
		return
	handle_animation(velocity)
	move_and_slide()
func _on_change_state_timer_timeout():
	var wait_time = 1
	if walking == true:
		not_walking = true
		walking = false
		wait_time = randi_range(1,5)
	elif not_walking == true:
		walking = true
		not_walking = false
		wait_time = randi_range(2,6)
	$ChangeStateTimer.wait_time = wait_time
	$ChangeStateTimer.start()





func _on_cow_wait_timer_timeout():
	cow_wait_timer_timeout = true

"""if ! in area -> cow wait"""
func start_cow_healing():
	#for i in range(0, len(Global.cows)):
	#	if Global.cows[i]["Name"] == self.name:
	#		if Global.cows[i]["Heal"] == true:
	start_healing = true
	$VetProgress.visible = true
	#print("Timer Started")
	$HealTime.start()
	$VetProgress.max_value = $HealTime.time_left

func _on_vet_heal(value):
	pass


func _on_vet_check_cows(cows_in_area):
	#for i in cows_in_area.size():
		if self.name in cows_in_area:
			cow_in_vet_area = true
			print("This cow hai area mein", self.name)
			if cow_health > 30:
				print(self.name, " is still healthy with health of: ", cow_health)
			elif cow_health <=30:
				start_cow_healing()
			#for i in range(1, len(Global.cows) + 1):
				#if Global.cows[i]["Name"] == self.name:
					#Global.cows[i]["Heal"] = true
					


func _on_world_cow_in_area(value):
	for i in range(0, len(Global.cows)):
		if Global.cows[i]["Name"] not in value:
			print(value)
			print("this cow is out of the fence", Global.cows[i]["Name"])
			
	
