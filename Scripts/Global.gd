extends Node

var gold = 10000
var milk_score : int = 0
var total_cattle_food : int = 30

var score = {
	"Milk" : 0,
	"Crop" : 30,
	#"Gold" : 10000
}

var items = {
	0: {
		"Name": "Milk",
		"CP": 60,
		"SP": 50,
		"Qty": 5,
	},
	
	1: {
		"Name": "Crop",
		"CP": 1000,
		"SP": 950,
		"Qty": 30
	},
}

var cows = {
	0: {
		"Name" : "Cow",
		"Heal" : false
	},
	
	1: {
		"Name" : "Cow2",
		"Heal" : false
	}
}
