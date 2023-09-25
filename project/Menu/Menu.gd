extends CanvasLayer
# Scrollable table of all the information based on search bar (if its blank it displays all),
# Button to add custom item, Back-to-main button

var state_machine = null

func enter(_msg := {}) -> void:
	pass

func exit() -> void:
	pass

func make_item_panel(item:Item)->void:
	var new_panel = $ItemPanels/ItemPanel.duplicate()

func _on_back_pressed():
	state_machine.transition_to("Main")
