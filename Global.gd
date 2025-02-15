extends Node
# Автозагружается как Autoload/Global

# Настройки игрока
var player_name: String = "Player"
var is_developer: bool = false
var sensitivity: float = 0.005
var controller_sensitivity: float = 0.01

# Сетевые настройки
const PORT: int = 9999
var enet_peer = ENetMultiplayerPeer.new()

func _ready():
    check_developer_status()

func check_developer_status():
    is_developer = (player_name == "AutoAuto" and OS.has_feature("standalone"))
