extends StaticBody2D

func _ready() -> void:
    yield(get_tree().create_timer(10.0), "timeout")
    $SpawningDoor.start_spawning()
