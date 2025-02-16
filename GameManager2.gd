extends Node

# Сигналы
signal player_list_updated

# Состояние игры
enum GameMode {FFA, TDM, CTF}
var current_mode: GameMode = GameMode.FFA
var players = {} # {peer_id: player_node}

func _ready():
    multiplayer.peer_connected.connect(_on_peer_connected)
    multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func start_host(map_path: String, mode: GameMode):
    # Создание сервера
    var peer = ENetMultiplayerPeer.new()
    peer.create_server(Global.PORT)
    multiplayer.multiplayer_peer = peer
    
    # Создание хоста как игрока
    var host_player = preload("res://player.tscn").instantiate()
    host_player.name = str(multiplayer.get_unique_id())
    host_player.player_name = Global.player_name
    add_child(host_player)
    players[host_player.name] = host_player
    
    # Загрузка карты
    load_map(map_path)

func _on_peer_connected(peer_id: int):
    # Обработка нового игрока
    var player = preload("res://player.tscn").instantiate()
    player.name = str(peer_id)
    add_child(player)
    players[peer_id] = player
    player_list_updated.emit()

func _on_peer_disconnected(peer_id: int):
    # Удаление отключившегося игрока
    players[peer_id].queue_free()
    players.erase(peer_id)
    player_list_updated.emit()
