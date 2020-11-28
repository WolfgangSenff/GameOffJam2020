extends StaticBody2D

signal all_enemies_killed

var remaining_enemy_count = 0

func initialize_level() -> void:
    $GismoTrigger/CollisionShape2D.set_deferred("disabled", true)
    yield(get_tree().create_timer(5.0), "timeout")
    yield($Grate.begin_oozing(), "completed")
    
    var all_enemies = get_tree().get_nodes_in_group("Enemy")
    if all_enemies.size() == 0:
        yield(finish_level(), "completed")
        emit_signal("all_enemies_killed")
    else:
        remaining_enemy_count = all_enemies.size()
        for enemy in all_enemies:
            enemy.connect("killed", self, "on_enemy_killed", [], CONNECT_ONESHOT)

func on_enemy_killed() -> void:
    remaining_enemy_count -= 1
    if remaining_enemy_count <= 0:
        yield(finish_level(), "completed")
        emit_signal("all_enemies_killed")

func enable_exit() -> void:
    get_tree().call_group("World", "switch_level", preload("res://resources/levels/Hub.tres"))
        
func finish_level() -> void:
    get_tree().get_nodes_in_group("Player")[0].give_next_weapon()
    $GismoTrigger/CollisionShape2D.set_deferred("disabled", false)
    yield($GismoTrigger, "trigger_tripped")
