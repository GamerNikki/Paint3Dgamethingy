extends Control

@onready var preview = $Preview/SubViewport/Preview
@onready var exit_button = $ExitButton
@onready var toggle_container := $ScrollContainer/VBoxContainer

var player: Node3D
var active_rig: Node3D = null
var rig_buttons: Array[Button] = []

const BODY_PARTS := [
	"Head",
	"Body",
	"LegLeft",
	"LegRight",
	"HandLeft",
	"HandRight",
	"Eyes",
	"Mouth",
	"Tail",
	"Ears",
	"Nose",
	"Hat"
]

# ---------------------------------------------------
# Ready
# ---------------------------------------------------
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	exit_button.pressed.connect(_on_exit)

# ---------------------------------------------------
# Player setup
# ---------------------------------------------------
func set_player(p: Node3D):
	player = p
	preview.set_player(p)
	_build_ui()

# ---------------------------------------------------
# UI builder
# ---------------------------------------------------
func _build_ui():
	for c in toggle_container.get_children():
		c.queue_free()

	rig_buttons.clear()

	var rigs := _get_all_rigs()
	if rigs.is_empty():
		return

	# Default to first rig (menu-only default; player load still wins)
	_set_active_rig(rigs[0])

	for rig in rigs:
		_create_rig_section(rig)

# ---------------------------------------------------
# Rig section
# ---------------------------------------------------
func _create_rig_section(rig: Node3D):
	var section := VBoxContainer.new()
	section.name = rig.name

	# ---- Rig select button ----
	var rig_btn := Button.new()
	rig_btn.text = "Use %s" % rig.name
	rig_btn.toggle_mode = true
	rig_btn.button_pressed = (rig == active_rig)

	rig_buttons.append(rig_btn)

	rig_btn.pressed.connect(func(b = rig_btn, r = rig):
		if not b.button_pressed:
			b.button_pressed = true
			return

		_set_active_rig(r)

		for other in rig_buttons:
			if other != b:
				other.button_pressed = false
	)

	section.add_child(rig_btn)

	# ---- Part toggles ----
	for part in BODY_PARTS:
		var normal := rig.get_node_or_null(part)
		var alt := rig.get_node_or_null(part + "_alt")

		# ✅ ONLY show parts that actually HAVE an alt
		if alt == null:
			continue

		var part_btn := Button.new()
		part_btn.text = "• %s" % part.capitalize()
		part_btn.toggle_mode = true

		# Initialize button from saved state if it exists
		if player.cosmetic_state.parts.has(part):
			part_btn.button_pressed = player.cosmetic_state.parts[part]

		part_btn.pressed.connect(func(b = part_btn, p = part, pl = player):
			pl.cosmetic_state.parts[p] = b.button_pressed
			pl._apply_cosmetics()
			pl._save_cosmetics()
		)

		section.add_child(part_btn)

	toggle_container.add_child(section)

# ---------------------------------------------------
# Rig control
# ---------------------------------------------------
func _set_active_rig(rig: Node3D):
	active_rig = rig
	for r in _get_all_rigs():
		r.visible = (r == rig)

	player.cosmetic_state.active_rig = rig.name
	player._apply_cosmetics()
	player._save_cosmetics()

	preview.update_display()

# ---------------------------------------------------
# Rig discovery
# ---------------------------------------------------
func _get_all_rigs() -> Array[Node3D]:
	var rigs: Array[Node3D] = []
	for child in player.get_children():
		if child is Node3D and child.name.begins_with("rig_A"):
			rigs.append(child)
	return rigs

# ---------------------------------------------------
# Exit
# ---------------------------------------------------
func _on_exit():
	queue_free()
	if player:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		player.set_physics_process(true)
		player.set_process_input(true)
