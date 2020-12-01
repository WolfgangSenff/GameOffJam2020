extends Area2D

export (Resource) var ConnectedLevel

func enable_exit() -> void:
    $CollisionShape2D.set_deferred("disabled", false)

func _on_LevelExit_area_entered(area: Area2D) -> void:
    if ConnectedLevel:
        get_tree().get_nodes_in_group("World")[0].switch_level(ConnectedLevel)
