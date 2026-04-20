extends Control

var player
@onready var grid = $ScrollContainer/GridContainer

func _ready():
	set_process_input(true)

func set_player(p):
	player = p
	_populate()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		close_menu()

func close_menu():
	if player:
		player.spawn_menu_instance = null
		
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		player.set_process_input(true)

	queue_free()

func _populate():
	for name in ItemDatabase.items.keys():
		var btn = Button.new()
		btn.text = name
		btn.pressed.connect(_spawn_item.bind(name))
		grid.add_child(btn)

func _spawn_item(name):
	var scene = ItemDatabase.items[name]
	var instance = scene.instantiate()

	# OPTION A: Put into inventory
	player.hold_item(instance)

	# OPTION B: Spawn in world instead
	# var spawn_pos = player.global_transform.origin + -player.camera.global_transform.basis.z * 3.0
	# get_tree().current_scene.add_child(instance)
	# instance.global_transform.origin = spawn_pos
