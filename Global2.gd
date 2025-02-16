# Автозагружается как Autoload/Global
# Хранит глобальные переменные и настройки игрока

extends Node

# Настройки игрока
var player_name: String = "Player"
var is_developer: bool = false
var sensitivity: float = 0.005
var controller_sensitivity: float = 0.01

# Прогресс игрока
var gold: int = 0          # Для кейсов
var currency: int = 0      # Для оружия
var level: int = 1
var xp: int = 0

# Разблокированный контент
var unlocked_weapons: Array = ["pistol", "rifle", "knife"]
var skins: Dictionary = {} # Формат: {weapon_type: {skin_id: data}}

# Сетевые настройки
const PORT: int = 9999
var enet_peer = ENetMultiplayerPeer.new()

func _ready():
    load_data()

func save_data():
    var config = ConfigFile.new()
    config.set_value("player", "name", player_name)
    config.set_value("progress", "gold", gold)
    config.set_value("progress", "currency", currency)
    config.set_value("progress", "level", level)
    config.set_value("progress", "xp", xp)
    config.save("user://save.cfg")

func load_data():
    var config = ConfigFile.new()
    config.load("user://save.cfg")
    player_name = config.get_value("player", "name", "Player")
    gold = config.get_value("progress", "gold", 0)
    currency = config.get_value("progress", "currency", 0)
    level = config.get_value("progress", "level", 1)
    xp = config.get_value("progress", "xp", 0)
