# Generic state machine. Initializes states and delegates engine callbacks
# (_physics_process, _unhandled_input) to the active state.
extends Node
class_name StateMachine


# Emitted when transitioning to a new state.
signal transitioned(state_name)

# The current active state. At the start of the game, we get the `initial_state`.
@onready var state = $Init


func _ready() -> void:
	# The state machine assigns itself to the State objects' state_machine property.
	for child in get_children():
		if child.name != "Debug":
			child.state_machine = self
	state.enter()


# The state machine subscribes to node callbacks and delegates them to the state objects.
func _unhandled_input(event: InputEvent) -> void:
	if state.has_method("handle_input"):
		state.handle_input(event)


func _process(delta: float) -> void:
	if state.has_method("update"):
		state.update(delta)

	for i in Global.items:
		$Debug/Label.text = i.item_name + "\n"


func _physics_process(delta: float) -> void:
	if state.has_method("physics_update"):
		state.physics_update(delta)


# This function calls the current state's exit() function, then changes the active state,
# and calls its enter function.
# It optionally takes a `msg` dictionary to pass to the next state's enter() function.
func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	# Safety check, you could use an assert() here to report an error if the state name is incorrect.
	# We don't use an assert here to help with code reuse. If you reuse a state in different state machines
	# but you don't want them all, they won't be able to transition to states that aren't in the scene tree.
	if not has_node(target_state_name):
		return

	state.exit()
	state.visible = false
	state = get_node(target_state_name)
	state.visible = true
	state.enter(msg)
	emit_signal("transitioned", state.name)
