extends Node

# Cosmetic storage
var cosmetics := {
	"heads": [],
	"bodies": [],
	"hands": [],
	"feet": [],
	"eyes": [],
	"mouths": [],
	"colors": []
}

# Paths
const HEADS_PATH  := "res://Assets/Cosmetics/Heads/"
const BODIES_PATH := "res://Assets/Cosmetics/Bodies/"
const HANDS_PATH  := "res://Assets/Cosmetics/Hands/"
const FEET_PATH   := "res://Assets/Cosmetics/Feet/"
const EYES_PATH   := "res://Assets/Cosmetics/Eyes/"
const MOUTHS_PATH := "res://Assets/Cosmetics/Mouths/"
const COLORS_PATH := "res://Materials/Colors/"

func _ready():
	load_all_cosmetics()

func load_all_cosmetics():
	cosmetics.heads  = load_folder_assets(HEADS_PATH)
	cosmetics.bodies = load_folder_assets(BODIES_PATH)
	cosmetics.hands  = load_folder_assets(HANDS_PATH)
	cosmetics.feet   = load_folder_assets(FEET_PATH)
	cosmetics.eyes   = load_folder_assets(EYES_PATH)
	cosmetics.mouths = load_folder_assets(MOUTHS_PATH)
	cosmetics.colors = load_color_materials(COLORS_PATH)

	print_debug_cosmetics()

func load_folder_assets(path: String) -> Array:
	var list := []
	var dir := DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			if not dir.current_is_dir() and not file.ends_with(".import"):
				var full_path = path + file
				var res = load(full_path)
				if res:
					list.append({"name": file.get_basename(), "resource": res, "path": full_path})
			file = dir.get_next()
	return list

func load_color_materials(path: String) -> Array:
	var list := []
	var dir := DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			if not dir.current_is_dir() and file.ends_with(".material"):
				var full_path = path + file
				var mat = load(full_path)
				if mat and mat is BaseMaterial3D:
					list.append({"name": file.get_basename(), "color": mat.albedo_color, "material": mat, "path": full_path})
			file = dir.get_next()
	return list

func print_debug_cosmetics():
	print("\n===== LOADED COSMETICS =====")
	for key in cosmetics.keys():
		print(key.capitalize(), ": ", cosmetics[key].size())
	print("============================\n")
