extends CanvasLayer

@onready var grid := $Panel/VBoxContainer/ColorsGrid
@onready var close_btn := $Panel/VBoxContainer/CloseButton

var player_ref = null
var materials := {}   # name → loaded material

func _ready():
	visible = false
	close_btn.pressed.connect(_on_close_pressed)
	_load_color_materials()
	_generate_buttons()

# Load all materials inside Materials/PlayerColors
func _load_color_materials():
	var dir := DirAccess.open("res://Materials/PlayerColors")
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			if file.ends_with(".tres") or file.ends_with(".material"):
				var path = "res://Materials/PlayerColors/" + file
				var mat = load(path)
				if mat:
					materials[file.get_basename()] = mat
			file = dir.get_next()
		dir.list_dir_end()

# Generate a button for each material
func _generate_buttons():
	for name in materials.keys():
		var btn := Button.new()
		btn.text = name
		btn.name = name
		btn.custom_minimum_size = Vector2(120, 40)

		# Color preview background
		var preview_color = materials[name].albedo_color
		var style = StyleBoxFlat.new()
		style.bg_color = preview_color
		style.corner_radius_all = 6
		btn.add_theme_stylebox_override("normal", style)

		btn.pressed.connect(_on_color_button_pressed.bind(name))
		grid.add_child(btn)

func open(player):
	player_ref = player
	visible = true

func _on_close_pressed():
	visible = false

func _on_color_button_pressed(color_name):
	var mat = materials[color_name]
	var color = mat.albedo_color

	if player_ref:
		player_ref.set_color_from_menu(color)
