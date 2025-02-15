extends CanvasLayer

@onready var player_list = $PlayerList

func update_player_list():
    var players = get_tree().get_nodes_in_group("players")
    player_list.clear()
    
    for player in players:
        var entry = "%s: %d Kills" % [player.player_name, player.kills]
        if player.is_developer:
            entry += " [DEV]"
        player_list.add_item(entry)

func _process(delta):
    update_player_list()
