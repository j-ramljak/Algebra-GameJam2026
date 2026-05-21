extends Node2D


var peer = ENetMultiplayerPeer.new()
@export var PlayerScene: PackedScene


func _on_host_b_pressed() -> void:
	
	peer.create_server(1027)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	_add_player()
	$".".hide()


func _add_player(id = 1):
	var player = PlayerScene.instantiate()
	player.name = str(id)
	print(id)
	#Globals.PlayerId = str(id)
	call_deferred("add_child",player)


func _on_join_b_pressed() -> void:
	
	peer.create_client("localhost", 1027)
	multiplayer.multiplayer_peer = peer
	$".".hide()

func exit_game(id):
	#print("Player exited!")
	#multiplayer.multiplayer_peer.disconnect_peer(id)
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)

func del_player(id):
	rpc("_del_player",id)

@rpc("any_peer","call_local")
func _del_player(id):
	print("Deleting player")
	get_node(str(id)).queue_free()
