extends Area3D

@export_file("*.tscn") var target_scene_path : String
@export var spawn_marker_name : String = "SpawnPoint"
@onready var audio : AudioStreamPlayer3D = $AudioStreamPlayer3D

var player_inside := false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta):
	if player_inside and Input.is_action_just_pressed("interact"):
		teleport()

func _on_body_entered(body):
	if body.name == "1": # your spawned player name
		player_inside = true

func _on_body_exited(body):
	if body.name == "1":
		player_inside = false

func teleport():
	audio.play()
	await audio.finished

	# Force spawn at 0,0,0
	GameState.next_spawn_position = Vector3.ZERO
	GameState.override_spawn = true

	get_tree().change_scene_to_file(target_scene_path)
