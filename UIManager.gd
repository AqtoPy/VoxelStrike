extends CanvasLayer

@onready var player_list = $PlayerList
@onready var scoreboard = $Scoreboard

func _ready():
    GameManager.player_list_updated.connect(update_player_list)

func update_player_list():
    player_list.clear()
    for player in GameManager.players.values():
        var entry = "%s [%d]" % [player.player_name, player.kills]
        if player.is_developer:
            entry += " ★"
        if player.name == str(multiplayer.get_unique_id()):
            entry += " (You)"
        player_list.add_item(entry)

func update_scoreboard():
    var scores = []
    for player in GameManager.players.values():
        scores.append({"name": player.name, "kills": player.kills})
    
    scores.sort_custom(func(a, b): return a.kills > b.kills)
    
    scoreboard.clear()
    for entry in scores:
        scoreboard.add_item("%s: %d kills" % [entry.name, entry.kills])
