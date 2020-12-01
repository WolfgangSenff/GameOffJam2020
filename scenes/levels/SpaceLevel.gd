extends StaticBody2D

signal all_enemies_killed
signal hide_abalam

var remaining_enemy_count = 0

func enable_exit() -> void:
    for exit in get_tree().get_nodes_in_group("LevelExit"):
        exit.enable_exit()

onready var camera = $Camera2D

func transfer_camera_to_point(_pos : Vector2) -> void:
    camera.position = _pos

func initialize_level() -> void:
    $MidToLeft.set_physics_process(false)
    $RightToMid.set_physics_process(true)
    $LightTrigger/AnimationPlayer.connect("animation_finished", self, "on_light_finished", [], CONNECT_ONESHOT)
    camera.global_position = $RightCameraPosition.global_position
    yield(get_tree(), "physics_frame")
    
func on_light_finished(animation) -> void:
    emit_signal("hide_abalam")

func _on_RightToMid_area_entered(area: Area2D) -> void:
    $RightToMid/CollisionShape2D.set_deferred("disabled", true)
    
    var spawn_in_node = get_tree().get_nodes_in_group("Spawner")[0]
    var first_door = swap_door($SpawningDoor, spawn_in_node)   
    var second_door = swap_door($SpawningDoor2, spawn_in_node) 
    first_door.start_spawning()
    yield(second_door.start_spawning(), "completed")
    var all_enemies = get_tree().get_nodes_in_group("Enemy")
    if all_enemies.size() == 0:
        emit_signal("all_enemies_killed")
        $MidToLeft.set_physics_process(true)
    else:
        remaining_enemy_count = all_enemies.size()
        for enemy in all_enemies:
            enemy.connect("killed", self, "on_enemy_killed", [], CONNECT_ONESHOT)

func swap_door(door, spawn) -> Node:
    remove_child(door)
    spawn.add_child(door)
    return door

func on_enemy_killed() -> void:
    remaining_enemy_count -= 1
    if remaining_enemy_count <= 0:
        $MidToLeft.set_physics_process(true)
        emit_signal("all_enemies_killed")
