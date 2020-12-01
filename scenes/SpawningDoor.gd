extends "res://scenes/DoorBase.gd"

export (Array, PackedScene) onready var EnemiesToSpawn
export (Array, float) var SpawnTimes

onready var spawn_position = $SpawnPosition
        
func start_spawning() -> void:
    yield(appear(), "completed")
    var enemy_spawn_index = 0
    var spawn_in_node = get_tree().get_nodes_in_group("Spawner")[0]
    
    for time in SpawnTimes:
        var enemy = EnemiesToSpawn[enemy_spawn_index].instance()
        yield(get_tree().create_timer(time), "timeout")
        yield(open_door(), "completed")
        spawn_in_node.add_child(enemy)
        enemy.global_position = spawn_position.global_position
        yield(close_door(), "completed")
        enemy_spawn_index += 1
        
    yield(get_tree().create_timer(1.5), "timeout")
    yield(disappear(), "completed")
