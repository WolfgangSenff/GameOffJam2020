extends "res://scenes/LevelBase.gd"

func initialize_level() -> void:
    $DoorTrigger/CollisionShape2D.disabled = GameState.hub_warehouse_complete
    $DoorTrigger2/CollisionShape2D.disabled = not (GameState.hub_science_complete and GameState.hub_warehouse_complete)
    $DoorTrigger3/CollisionShape2D.disabled = (GameState.hub_science_complete or not GameState.hub_warehouse_complete)
    yield(get_tree(), "physics_frame")
