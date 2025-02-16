extends CanvasLayer

# Цены и контент
const WEAPON_PRICES = {
    "shotgun": 1500,
    "sniper": 3000,
    "smg": 2000
}

@onready var currency_label = $CurrencyLabel

func _ready():
    update_display()

func update_display():
    currency_label.text = "Credits: %d" % Global.currency
    # Обновление кнопок оружия...

func _on_weapon_purchased(weapon_name: String):
    if Global.currency >= WEAPON_PRICES[weapon_name]:
        Global.currency -= WEAPON_PRICES[weapon_name]
        Global.unlocked_weapons.append(weapon_name)
        Global.save_data()
