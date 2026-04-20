extends Node
# Optional: remove class_name if you already have an autoload
# class_name MultiplayerManager

var username := ""
var is_host := false
var peer_order := []   # Stores peer IDs in connection order

func create_server(port: int):
	is_host = true
	var peer := ENetMultiplayerPeer.new()
	peer.create_server(port, 32)
	get_tree().multiplayer.multiplayer_peer = peer

	peer_order.clear()
	peer_order.append(get_tree().multiplayer.get_unique_id()) # Host ID

	print("Server started on port:", port)

	# Signals
	get_tree().multiplayer.peer_connected.connect(_on_peer_connected)
	get_tree().multiplayer.peer_disconnected.connect(_on_peer_disconnected)


func connect_to_server(ip: String, port: int):
	is_host = false
	var peer := ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	get_tree().multiplayer.multiplayer_peer = peer

	print("Connecting to:", ip, ":", port)

	# Signals
	get_tree().multiplayer.peer_connected.connect(_on_peer_connected)
	get_tree().multiplayer.peer_disconnected.connect(_on_peer_disconnected)


func _on_peer_connected(id: int):
	peer_order.append(id)
	print("Peer connected:", id, "order:", peer_order)


func _on_peer_disconnected(id: int):
	print("Peer disconnected:", id)
	peer_order.erase(id)

	# If server owner disconnects, transfer ownership
	if is_host and id == get_tree().multiplayer.get_unique_id():
		_migrate_host()

	# If no peers left → shutdown
	if peer_order.size() == 0:
		print("No peers left — shutting down server")
		_shutdown_server()


func _migrate_host():
	print("Host migrated!")

	if peer_order.size() == 0:
		_shutdown_server()
		return

	var new_host_id = peer_order[0]   # Next oldest client
	print("Transferring host to:", new_host_id)
	# Godot 4 doesn't have set_transfer_channel; handle manually
	is_host = (get_tree().multiplayer.get_unique_id() == new_host_id)


func _shutdown_server():
	if get_tree().multiplayer.multiplayer_peer:
		get_tree().multiplayer.multiplayer_peer.close()
	get_tree().multiplayer.multiplayer_peer = null
	print("Server shut down.")
