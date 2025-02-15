extends CharacterBody3D

@export var player_name: String = "Player"
@export var is_developer: bool = false
@export var kills: int = 0
@export var deaths: int = 0

@onready var camera = $Camera3D
@onready var name_label = $NameLabel
@onready var dev_icon = $DevIcon
@onready var death_overlay = $DeathOverlay

const DEVELOPER_MATERIAL = preload("res://materials/developer.tres")
const SPAWN_POINTS = [
    Vector3(-18, 0.2, 0),
    Vector3(18, 0.2, 0),
    Vector3(-2.8, 0.2, -6)
]

func _ready():
    if is_multiplayer_authority():
        set_multiplayer_authority(str(name).to_int())
        update_player_data.rpc(Global.player_name, Global.is_developer)
    
    setup_appearance()

func setup_appearance():
    name_label.text = player_name
    dev_icon.visible = is_developer
    if is_developer:
        $MeshInstance3D.material_override = DEVELOPER_MATERIAL

@rpc("any_peer", "call_local")
func update_player_data(name: String, developer: bool):
    player_name = name
    is_developer = developer
    setup_appearance()

@rpc("any_peer")
func receive_damage(attacker_id: int):
    if multiplayer.is_server():
        var attacker = get_node(str(attacker_id))
        deaths += 1
        attacker.kills += 1
        show_death_ui.rpc(attacker.player_name)
        respawn.rpc()

@rpc("call_local")
func show_death_ui(killer_name: String):
    death_overlay.show()
    death_overlay/Label.text = "Killed by: %s" % killer_name
    await get_tree().create_timer(5.0).timeout
    death_overlay.hide()

@rpc("call_local")
func respawn():
    position = SPAWN_POINTS[randi() % SPAWN_POINTS.size()]
    health = 100
