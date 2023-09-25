extends CanvasLayer

var state_machine = null

func enter(_msg := {}) -> void:
	pass

func exit() -> void:
	clear_fields()

func _on_save_pressed():
	var item = Item.new()
	item.item_name = $Panel/VBoxContainer/Name.text
	item.price = $Panel/VBoxContainer/Price.text
	item.score = int($Panel/VBoxContainer/Score.text)
	item.calories = int($Panel/VBoxContainer/Calories.text)
	item.drink = $Panel/VBoxContainer/Drink.button_pressed
	
	Global.add_item(item)
	Global.save_items()
	
	clear_fields()
	
func _on_back_pressed():
	state_machine.transition_to("Menu")

func clear_fields():
	$Panel/VBoxContainer/Name.text = ""
	$Panel/VBoxContainer/Price.text = ""
	$Panel/VBoxContainer/Score.text = ""
	$Panel/VBoxContainer/Calories.text = ""
	$Panel/VBoxContainer/Drink.button_pressed = false
