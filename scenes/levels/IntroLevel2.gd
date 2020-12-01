extends "res://scenes/LevelBase.gd"

func initialize_level() -> void:
    yield(get_tree(), "physics_frame")
