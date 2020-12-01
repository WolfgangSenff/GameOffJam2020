extends "res://scenes/LevelBase.gd"

var remaining_enemy_count = 0

func initialize_level() -> void:
    yield(get_tree().create_timer(2.0), "timeout")
    yield($SpawningDoor.start_spawning(), "completed")
    
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
