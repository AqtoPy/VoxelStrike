extends CharacterBody3D

# Экспортируемые параметры
@export var player_name: String = "Player"
@export var is_developer: bool = false
@export var kills: int = 0
@export var deaths: int = 0

# Референсы на ноды
@onready var camera = $Camera3D
@onready var name_label = $NameLabel
@onready var level_label = $LevelLabel

# Настройки движения
const SPEED = 5.5
const JUMP_VELOCITY = 4.5
var current_weapon: String = "rifle"

func _ready():
    if is_multiplayer_authority():
        setup_local_player()
    else:
        setup_remote_player()

func setup_local_player():
    # Инициализация локального игрока
    camera.current = true
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    update_player_data.rpc(Global.player_name, Global.level, Global.is_developer)

func setup_remote_player():
    # Настройка для удаленных игроков
    name_label.text = player_name
    level_label.text = "Lv.%d" % level

@rpc("any_peer", "call_local")
func update_player_data(name: String, lvl: int, developer: bool):
    # Синхронизация данных по сети
    player_name = name
    level = lvl
    is_developer = developer
    update_appearance()

func update_appearance():
    # Визуальное обновление
    name_label.text = player_name
    level_label.text = "Lv.%d" % level
    if is_developer:
        $DeveloperIcon.show()
        $Mesh.material_override = preload("res://materials/developer.tres")
