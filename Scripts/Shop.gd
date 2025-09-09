extends StaticBody2D

var player_in_area : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.visible = false
	$ShopUI.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_in_area:
		
		if Input.is_action_just_pressed("Interact"):
			get_tree().paused = true
			get_node("ShopUI/AnimationPlayer").play("transIn")
	

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		$Label.visible = true
		player_in_area = true
		$ShopUI.visible = true
		#get_tree().paused = true
		#get_node("ShopUI/AnimationPlayer").play("transIn")


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		$Label.visible = false
		$ShopUI.visible = false
		player_in_area = false
