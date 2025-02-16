extends CanvasLayer

# Настройки кейсов
enum Rarity {COMMON, RARE, EPIC, LEGENDARY, ULTRA}
const CASE_DROP_RATES = {
    Rarity.COMMON: 70.0,
    Rarity.RARE: 25.0,
    Rarity.EPIC: 4.9,
    Rarity.ULTRA: 0.1
}

@onready var animation_player = $AnimationPlayer

func open_case(case_type: String):
    if Global.gold < get_case_price(case_type):
        return
    
    Global.gold -= get_case_price(case_type)
    var rarity = calculate_rarity()
    var skin = generate_skin(rarity)
    
    animation_player.play("open")
    await animation_player.animation_finished
    
    Global.skins[skin.weapon_type] = skin
    Global.save_data()

func calculate_rarity() -> Rarity:
    var roll = randf() * 100
    for rarity in CASE_DROP_RATES:
        if roll <= CASE_DROP_RATES[rarity]:
            return rarity
        roll -= CASE_DROP_RATES[rarity]
    return Rarity.COMMON
