extends "res://scenes/LevelBase.gd"

var remaining_enemy_count = 0

func initialize_level() -> void:
    yield($SpawningDoor.start_spawning(), "completed")
    yield($SpawningDoor2.start_spawning(), "completed")
    yield($SpawningDoor3.start_spawning(), "completed")
    yield($SpawningDoor4.start_spawning(), "completed")
    yield(get_tree(), "physics_frame")
    
    var all_enemies = get_tree().get_nodes_in_group("Enemy")
    if all_enemies.size() == 0:
        emit_signal("all_enemies_killed")
    else:
        remaining_enemy_count = all_enemies.size()
        for enemy in all_enemies:
            enemy.connect("killed", self, "on_enemy_killed", [], CONNECT_ONESHOT)

func on_enemy_killed() -> void:
    remaining_enemy_count -= 1
    if remaining_enemy_count == 0:
        emit_signal("all_enemies_killed")
