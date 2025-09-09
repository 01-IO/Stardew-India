extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$"Milk Amount".text = ": " + str(Global.score["Milk"])
	$CattleFood.text = ": " + str(Global.score["Crop"])
	$"Coin Amount".text = ": " + str(Global.gold)
