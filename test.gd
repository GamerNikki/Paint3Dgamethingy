@tool
extends EditorScript
func _ready():
	if Engine.has_singleton("CosmeticLoader"):
		print("CosmeticLoader singleton is available!")
	else:
		push_error("CosmeticLoader singleton not found!")
