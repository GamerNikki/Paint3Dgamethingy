extends Node3D

@onready var rig := $worldedit/PlayerPreview/rig

var player_ref

func _ready():
	# Always run, even if game is paused or viewport is isolated
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Force SubViewport to redraw
	var vp := get_viewport()
	if vp is SubViewport:
		vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS

func set_player(p):
	player_ref = p
	update_display()

func update_display():
	if not player_ref:
		return

	apply_color(player_ref.cosmetics.color)

func apply_color(color: Color):
	for mesh in rig.get_children():
		if mesh is MeshInstance3D:
			# Always use an override material (safe for imported meshes)
			var base_mat := mesh.get_active_material(0) as StandardMaterial3D
			if base_mat:
				var new_mat := base_mat.duplicate() as StandardMaterial3D
				new_mat.albedo_color = color
				mesh.set_surface_override_material(0, new_mat)
