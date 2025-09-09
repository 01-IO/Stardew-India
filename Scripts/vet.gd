extends StaticBody2D

signal heal(value)
signal check_cows(cows_in_area)
var player_in_area : bool = false

@onready var world_data = get_parent()

@onready var cow : CharacterBody2D = get_parent().get_node("Cow")
@onready var cow_2 : CharacterBody2D = get_parent().get_node("Cow2")
var cows_in_area : Array = []

func _ready():
	$VetMenu.visible = false
	$Label.visible = false
	print(Global.cows[0]["Name"])
func _process(delta):
	
	
	if player_in_area:
		if Input.is_action_just_pressed("Interact"):
			$VetMenu.visible = true
			

		if cows_in_area != []:
			#for i in range(len(Global.cows)):
			if Input.is_action_just_pressed("Heal"):
				emit_signal("check_cows", cows_in_area)


			#print(cows_in_area[0].name)
			#print(cows_in_area)
			
				#emit_signal("heal", true)
				
	
						#Global.cows[]
				print("HEALING THE COW")
		#else:
		#	print("No cows in the area, bring your cows to be healed")
		#print(cows_in_area[0].position)
#func handle_cow():
	#if $VetMenu.button_just_pressed == true:
		#print("Fixing cow")
		#
		#$VetMenu.button_just_pressed = false
func handle_cow():
	print(cow.get_node("$VetProgress"))
	
func _on_interact_w_player_body_entered(body): 
	if body.name == "Player":
	
		player_in_area = true
		$Label.visible = true

func _on_interact_w_player_body_exited(body):
	if body.name == "Player":
		player_in_area = false
		$VetMenu.visible = false
		$Label.visible = false


func _on_cow_detector_body_entered(body):
	for i in range(0, len(Global.cows)):
		if Global.cows[i]["Name"] == body.name:
			cows_in_area.append(body.name)
			print(cows_in_area)
		#if Global.cows[i]["Name"] in cows_in_area:
			#print(Global.cows[1]["Heal"])
			#Global.cows[i]["Heal"] = true
		#	print(body.name)
	# make a detection mechanism for each cow varna only if the pllayer is in the area all the cows are getting healed
	# only cow brought into the area will be healed and the money will be deducted
	#create an array for the cows in the region. The cow name will be removed from the array once it leaves the detection zone


func _on_cow_detector_body_exited(body):
	for i in range(0, len(Global.cows)):
		if Global.cows[i]["Name"] == body.name:
			cows_in_area.erase(body.name)
			print(cows_in_area)
			
		#	print(body.name)
