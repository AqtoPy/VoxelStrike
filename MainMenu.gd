extends Control

@onready var name_input = $VBoxContainer/NameInput
@onready var error_label = $VBoxContainer/ErrorLabel

func _on_host_pressed():
    if validate_name():
        Global.player_name = name_input.text
        start_host()

func _on_join_pressed():
    if validate_name():
        Global.player_name = name_input.text
        start_client()

func validate_name() -> bool:
    var name = name_input.text.strip_edges()
    
    if name == "AutoAuto":
        error_label.text = "This name is reserved!"
        return false
        
    if name.length() < 3 || name.length() > 16:
        error_label.text = "Name must be 3-16 characters"
        return false
        
    return true

func start_host():
    var peer = ENetMultiplayerPeer.new()
    peer.create_server(PORT)
    multiplayer.multiplayer_peer = peer
    hide()
    # Дополнительная логика инициализации уровня

func start_client():
    var peer = ENetMultiplayerPeer.new()
    peer.create_client("localhost", PORT)
    multiplayer.multiplayer_peer = peer
    hide()
