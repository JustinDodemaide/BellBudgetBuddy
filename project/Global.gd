extends Node

var items:Array[Item] = []

func add_item(item:Item)->void:
	#print("adding new item")
	items.append(item)
	
func remove_item(item:Item)->void:
	var iterator:int = 0
	for i in items:
		if i.equals(item):
			items.remove_at(iterator)
			break
		iterator += 1

func save_items()->void:
	var text_file = FileAccess.open("user://Items.save", FileAccess.WRITE)
	if text_file == null:
		return
	if not text_file.is_open():
		return
	#assert(text_file.is_open())
	var not_first = false
	for i in items:
		text_file.seek_end()
		if not_first:
			text_file.store_string("\n")
		not_first = true
		var string = JSON.stringify(i.save())
		#print("Save string ", string)
		text_file.store_string(string)
	text_file.close()
