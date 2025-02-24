extends MarginContainer

@onready var button: LinkButton = %Button

signal pressed

@export var text: String:
	set = _set_text

func _set_text(new_text):
	text = new_text
	await ready
	button.text = new_text
	button.pressed.connect(func (): pressed.emit())
