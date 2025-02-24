extends Node2D

@onready var _ink_player = %InkPlayer
@onready var dialogue: MyDialogue = %Dialogue

func _ready():
	_ink_player.loaded.connect(_story_loaded)
	_ink_player.create_story()
	dialogue.player_text = ""
	dialogue.npc_text = ""
	dialogue.choice_made.connect(_select_choice)


func _story_loaded(successfully: bool):
	if !successfully:
		return

	# _observe_variables()
	# _bind_externals()

	_continue_story()


# ############################################################################ #
# Private Methods
# ############################################################################ #

func _continue_story():
	while _ink_player.can_continue:
		var text = _ink_player.continue_story()
		if not dialogue.player_text:
			# Assuming that the next text after user choice is the player answer.
			dialogue.player_text = text
		else:
			dialogue.npc_text = text

	if _ink_player.has_choices:
		var new_options: Array[String] = []
		for choice in _ink_player.current_choices:
			new_options.append(choice.text)
			# print(choice.tags)
		dialogue.options = new_options
		dialogue.animate()
	else:
		dialogue.visible = false
		print("The End")


func _select_choice(index):
	dialogue.player_text = ""
	_ink_player.choose_choice_index(index)
	_continue_story()


# Uncomment to bind an external function.
#
# func _bind_externals():
# 	_ink_player.bind_external_function("<function_name>", self, "_external_function")
#
#
# func _external_function(arg1, arg2):
# 	pass


# Uncomment to observe the variables from your ink story.
# You can observe multiple variables by putting adding them in the array.
# func _observe_variables():
# 	_ink_player.observe_variables(["var1", "var2"], self, "_variable_changed")
#
#
# func _variable_changed(variable_name, new_value):
# 	print("Variable '%s' changed to: %s" %[variable_name, new_value])
