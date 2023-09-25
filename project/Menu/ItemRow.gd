class_name ItemRow

var item:Item
var elements:Array
signal changed

func _init(_item:Item):
	item = _item
	
func get_row_elements()->Array:
	var row = []
	# Name
	var name_label = new_label(item.item_name)
	name_label.custom_minimum_size.x = 150
	name_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	row.append(name_label)
	
	# Score
	var line = LineEdit.new()
	var score = str(item.score)
	line.text = score
	line.placeholder_text = "0-10"
	line.text_changed.connect(score_changed)
	row.append(line)
	
	# Price
	row.append(new_label(str(item.price)))
	
	# Calories
	row.append(new_label(str(item.calories)))
	
	# Remove button
	var remove_button = load("res://Menu/RemoveButton/RemoveButton.tscn").instantiate()
	remove_button.pressed.connect(remove)
	row.append(remove_button)
	elements = row
	return row
	
func remove():
	Global.remove_item(item)
	remove_elements()
	emit_signal("changed")

func remove_elements():
	if elements.is_empty():
		return
	for i in elements:
		i.queue_free()
	elements.clear()
		
func score_changed(new_text):
	var new_score = int(new_text)
	#if new_score > 10 or new_score < 0:
	#	return
	# If someone decides they hate a menu item so much they rate it -1,
	# or love an item so much they rate it 11, who am I to stop them
	item.score = new_score
	emit_signal("changed")

func new_label(text:String)->Label:
	var label = Label.new()
	label.text = text
	return label
