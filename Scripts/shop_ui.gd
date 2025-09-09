extends CanvasLayer

var currItem = 0
var select = 0

func _ready():
	switchItem(currItem)

func _on_close_pressed():
	$AnimationPlayer.play("transOut")
	get_tree().paused = false
	
func switchItem(select):
	print(Global.items.size())
	for i in Global.items.size():
		if select == i:
			currItem = select
			
			$Control/AnimatedSprite2D.play(Global.items[currItem]["Name"])
			$Control/Name.text = Global.items[currItem]["Name"]
			$Control/sellingPrice.text = str(Global.items[currItem]["SP"])
			$Control/costPrice.text = str(Global.items[currItem]["CP"])
			$Control/Qty.text = str(Global.items[currItem]["Qty"])
			if Global.items[currItem]["Name"] == "Crop":
				$Control/AnimatedSprite2D.scale = Vector2(5, 5)
			elif Global.items[currItem]["Name"] == "Milk":
				$Control/AnimatedSprite2D.scale = Vector2(1, 1)

func _on_previous_pressed():
	switchItem(currItem - 1)


func _on_next_pressed():
	switchItem(currItem + 1)


func _on_buy_pressed():
	#if Global.items[currItem]["Name"] == "Crop":
		#Global.gold -= Global.items[currItem]["CP"]
		#Global.total_cattle_food += Global.items[currItem]["Qty"]
	#elif Global.items[currItem]["Name"] == "Milk":
		#Global.gold -= Global.items[currItem]["CP"]
		#Global.milk_score += Global.items[currItem]["Qty"] 


	for i in Global.score:
		if i == Global.items[currItem]["Name"]:
			if Global.gold != 0:
				Global.gold -= Global.items[currItem]["CP"]
				Global.score[i] += Global.items[currItem]["Qty"] 
				print(Global.items[currItem]["Name"], " ", Global.score[i])
			else:
				print("NO MONEY!!! for ", Global.items[currItem]["Name"])
func _on_sell_pressed():
	#if Global.items[currItem]["Name"] == "Crop":
		#if Global.total_cattle_food > 0 and Global.total_cattle_food % Global.items[currItem]["Qty"] == 0:
			#Global.gold += Global.items[currItem]["SP"]
			#Global.total_cattle_food -= Global.items[currItem]["Qty"]
		#else:
			#print("get more crop")
	#elif Global.items[currItem]["Name"] == "Milk":
		#if Global.milk_score > 0 and Global.milk_score % Global.items[currItem]["Qty"] == 0:
			#Global.gold += Global.items[currItem]["SP"]
			#Global.milk_score -= Global.items[currItem]["Qty"] 
		#else:
			#print("get more milk")
	
	for i in Global.score:
		if i == Global.items[currItem]["Name"]:
			if Global.score[i] > 0 and Global.score[i] % Global.items[currItem]["Qty"] == 0:
				Global.gold += Global.items[currItem]["SP"]
				Global.score[i] -= Global.items[currItem]["Qty"] 
				print(Global.items[currItem]["Name"], " ", Global.score[i])
			else:
				print("GET MORE!!!! ", Global.items[currItem]["Name"])
