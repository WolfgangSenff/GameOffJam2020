extends "res://scenes/LevelBase.gd"

export (Array, float) var TimesBetweenEnemySpawns

onready var doors = $Doors

var remaining_enemy_count = 0

func initialize_level() -> void:
    var child_idx = 0
    var door_children = doors.get_children()
    var spawner = get_tree().get_nodes_in_group("Spawner")[0]

    for time in TimesBetweenEnemySpawns:
        var door = door_children[child_idx]
        doors.remove_child(door)
        spawner.add_child(door)
        yield(get_tree().create_timer(time), "timeout")
        yield(door.start_spawning(), "completed")
        child_idx += 1
    
    var all_enemies = get_tree().get_nodes_in_group("Enemy")
    if all_enemies.size() == 0:
        emit_signal("all_enemies_killed")
    else:
        remaining_enemy_count = all_enemies.size()
        for enemy in all_enemies:
            enemy.connect("killed", self, "on_enemy_killed", [], CONNECT_ONESHOT)
        
    yield(get_tree(), "physics_frame")


func on_enemy_killed() -> void:
    remaining_enemy_count -= 1
    if remaining_enemy_count <= 0:
        emit_signal("all_enemies_killed")
