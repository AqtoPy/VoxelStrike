extends Node

var players = {}

func _ready():
    multiplayer.peer_connected.connect(_on_peer_connected)
    multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func _on_peer_connected(id: int):
    var player = preload("res://player.tscn").instantiate()
    player.name = str(id)
    add_child(player)
    
    if player.player_name in players.values():
        kick_player(id, "Name already exists")
        return
        
    players[id] = player.player_name

func _on_peer_disconnected(id: int):
    if players.has(id):
        players.erase(id)

func kick_player(id: int, reason: String):
    var peer = multiplayer.multiplayer_peer as ENetMultiplayerPeer
    peer.disconnect_peer(id, true)
    print("Kicked player %d: %s" % [id, reason])
