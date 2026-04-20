extends Control

signal resume_requested
signal keybinds_requested
signal leave_lobby_requested

@onready var panel = $Panel
@onready var resume_button = $Panel/VBoxContainer/ResumeButton
@onready var keybinds_button = $Panel/VBoxContainer/KeybindsButton
@onready var leave_lobby_button = $Panel/VBoxContainer/LeaveLobbyButton

func _ready():
	resume_button.pressed.connect(_on_resume_pressed)
	keybinds_button.pressed.connect(_on_keybinds_pressed)
	leave_lobby_button.pressed.connect(_on_leave_lobby_pressed)

	hide() # Start hidden

func show_menu():
	visible = true
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func hide_menu():
	visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_resume_pressed():
	hide_menu()
	emit_signal("resume_requested")

func _on_keybinds_pressed():
	emit_signal("keybinds_requested")

func _on_leave_lobby_pressed():
	emit_signal("leave_lobby_requested")
