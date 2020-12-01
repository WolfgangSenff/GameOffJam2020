extends "res://scenes/PlayerTrigger.gd"

func trigger_entered():
    get_tree().call_group("Player", "give_next_weapon")
