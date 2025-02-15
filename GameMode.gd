class_name GameMode

static func get_mode_name(mode: int) -> String:
    match mode:
        GameManager.GameMode.FFA: return "Все против всех"
        GameManager.GameMode.TDM: return "Командный бой"
        GameManager.GameMode.CTF: return "Захват флага"
        _: return "Неизвестный режим"

static func setup_mode(mode: int):
    match mode:
        GameManager.GameMode.FFA:
            GameSettings.team_play = false
            GameSettings.score_limit = 50
        GameManager.GameMode.TDM:
            GameSettings.team_play = true
            GameSettings.score_limit = 100
        GameManager.GameMode.CTF:
            GameSettings.team_play = true
            GameSettings.objective_based = true
