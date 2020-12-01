extends StaticBody2D

signal all_enemies_killed
signal hide_abalam

func enable_exit() -> void:
    for exit in get_tree().get_nodes_in_group("LevelExit"):
        exit.enable_exit()
        
func initialize_level() -> void:
    yield(get_tree(), "physics_frame")
