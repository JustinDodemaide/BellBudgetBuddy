extends CanvasLayer

var state_machine = null

func enter(_msg := {}) -> void:
	
	load_items()

func exit() -> void:
	pass

func load_items()->void:
	if not FileAccess.file_exists("user://Items.save"):
		state_machine.transition_to("Main")
		print("file doesnt exist")
		return # Error! We don't have a save to load.

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_file = FileAccess.open("user://Items.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var line = save_file.get_line()
		# Get the data from the JSON object
		var item_data:Dictionary = JSON.parse_string(line)

		var new_item = Item.new()
		new_item._load(item_data)
		Global.add_item(new_item)
	#print("items loaded")
	state_machine.transition_to("Main")
