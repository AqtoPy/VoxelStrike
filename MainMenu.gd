extends Control

@onready var name_input = $VBoxContainer/NameInput
@onready var map_selector = $VBoxContainer/MapSelector
@onready var mode_selector = $VBoxContainer/ModeSelector
@onready var error_label = $VBoxContainer/ErrorLabel

func _ready():
    # Инициализация списка карт
    map_selector.add_item("Карьеры", "res://maps/quarry.tscn")
    map_selector.add_item("Город", "res://maps/city.tscn")
    map_selector.add_item("Бункер", "res://maps/bunker.tscn")
    
    # Инициализация режимов
    mode_selector.add_item("Все против всех")
    mode_selector.add_item("Командный бой")
    mode_selector.add_item("Захват флага")

func _on_host_pressed():
    if validate_inputs():
        Global.player_name = name_input.text
        Global.check_developer_status()
        GameManager.start_host(
            map_selector.get_selected_metadata(),
            mode_selector.selected
        )
        hide()

func _on_join_pressed():
    if validate_name():
        Global.player_name = name_input.text
        # ... подключение клиента

func validate_inputs() -> bool:
    if !validate_name():
        return false
        
    if map_selector.selected == -1:
        error_label.text = "Выберите карту!"
        return false
        
    if mode_selector.selected == -1:
        error_label.text = "Выберите режим!"
        return false
        
    return true
