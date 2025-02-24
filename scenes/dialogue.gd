class_name MyDialogue
extends Control

signal choice_made(choice)

@onready var player_label: Label = %PlayerLabel
@onready var npc_label: Label = %NPCLabel
@onready var options_container: VBoxContainer = %OptionsContainer
@onready var npc_box: MarginContainer = %NPCBox

@export var player_text: String:
	set = _set_player_text

@export var npc_text: String:
	set = _set_npc_text

@export var options: Array[String]:
	set = _set_options

const BUTTON = preload("res://scenes/button.tscn")

func _set_player_text(new_text):
	player_text = new_text
	if not is_node_ready():
		return
	player_label.text = new_text
	player_label.visible = not not new_text

func _set_npc_text(new_text):
	npc_text = new_text
	if not is_node_ready():
		return
	npc_label.text = new_text
	npc_box.visible = not not new_text

func _set_options(new_options):
	options = new_options
	if not is_node_ready():
		return
	for node in options_container.get_children():
		options_container.remove_child(node)
		node.queue_free()
	for index in options.size():
		var button = BUTTON.instantiate()
		button.text = options[index]
		button.pressed.connect(_on_button_clicked.bind(index))
		options_container.add_child(button)

func _on_button_clicked(index):
	DampedOscillator.animate(self, "scale", 200, 10, 15, 0.3)
	choice_made.emit(index)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_player_text(player_text)
	_set_npc_text(npc_text)
	_set_options(options)

func animate() -> void:
	options_container.modulate = Color.TRANSPARENT
	if player_label.text:
		player_label.visible_ratio = 0
	if npc_label.text:
		npc_label.visible_ratio = 0
	if player_label.text:
		var player_tween = get_tree().create_tween()
		player_tween.tween_property(player_label, "visible_ratio", 1, 1)
		player_tween.play()
		await player_tween.finished
	if npc_label.text:
		var npc_tween = get_tree().create_tween()
		npc_tween.tween_property(npc_label, "visible_ratio", 1, 1)
		npc_tween.play()
		await npc_tween.finished
	var options_tween = get_tree().create_tween()
	options_tween.tween_property(options_container, "modulate", Color.WHITE, 0.3)
	await options_tween.finished
