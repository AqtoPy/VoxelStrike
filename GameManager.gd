extends Node

enum GameMode {FFA, TDM, CTF}
var current_map: String
var current_mode: GameMode

func start_host(map_path: String, mode: int):
    # Загрузка карты
    var map_scene = load(map_path)
    var map_instance = map_scene.instantiate()
    get_tree().root.add_child(map_instance)
    
    # Настройка сервера
    var peer = ENetMultiplayerPeer.new()
    peer.create_server(Global.PORT)
    multiplayer.multiplayer_peer = peer
    
    # Инициализация режима
    current_mode = mode
    current_map = map_path
    
    # Синхронизация с клиентами
    sync_game_settings.rpc(map_path, mode)

@rpc("call_local")
func sync_game_settings(map: String, mode: int):
    current_map = map
    current_mode = mode
    # Загрузка карты для клиентов
    if !FileAccess.file_exists(map):
        push_error("Map file not found!")
        return
        
    var map_scene = load(map)
    get_tree().root.get_child(0).queue_free()
    get_tree().root.add_child(map_scene.instantiate())

func _on_peer_connected(id: int):
    # Отправляем новые игрокам настройки
    sync_game_settings.rpc_id(id, current_map, current_mode)
