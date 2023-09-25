class_name Item

var item_name:String = ""
var price:float = 0.00
var score:int = 0
var calories:int = 0
var drink:bool = false

func equals(item:Item)->bool:
	return item.item_name == item_name

func save()->Dictionary:
	var save_dict = {
		"name": item_name,
		"price": price,
		"score": score,
		"calories": calories,
		"drink": drink
	}
	return save_dict
	
func _load(save_dict:Dictionary):
	#print("savedictname: ", save_dict["name"])
	item_name = save_dict["name"]
	price = float(save_dict["price"])
	score = int(save_dict["score"])
	calories = int(save_dict["calories"])
	drink = bool(save_dict["drink"])
