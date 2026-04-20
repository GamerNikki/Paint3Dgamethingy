# inventory_item.gd
extends Area3D
class_name InventoryItem

@export var icon: Texture2D

func pickup_self():
	return self
