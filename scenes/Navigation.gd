extends Navigation2D

onready var wandering_points = $WanderingPoints

func get_random_wandering_position() -> Vector2:
    return wandering_points.get_children()[randi() % wandering_points.get_child_count()].position
