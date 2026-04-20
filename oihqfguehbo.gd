# GlobalPlayerSpawner.gd
extends Node

# Set your player scene path here
var player_scene_path := "res://Player.tscn"

# Optional: name to identify the player instance in the tree
var player_node_name := "Player"

func spawn_player():
	# If a player already exists, keep it and do nothing
	if get_tree().root.has_node(player_node_name):
		return
	
	# Load and instantiate the player scene
	var player_scene = load(player_scene_path)
	var player_instance = player_scene.instantiate()
	player_instance.name = player_node_name
	
	# Set the player's position at the origin
	if player_instance.has_method("set_global_transform"):
		player_instance.global_transform.origin = Vector3.ZERO
	elif player_instance.has_variable("global_position"): # For 2D
		player_instance.global_position = Vector2.ZERO
	
	# Add player directly to the root of the scene tree
	get_tree().root.add_child(player_instance)
