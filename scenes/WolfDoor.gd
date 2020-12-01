extends Node2D

const WolfScene = preload("res://scenes/WolfBoss.tscn")

onready var anim = $AnimationPlayer

func start_spawning() -> void:
    anim.play("Open")
    yield(anim, "animation_finished")
    
func spawn_wolf() -> void:
    var wolf = WolfScene.instance()
    get_tree().get_nodes_in_group("Spawner")[0].add_child(wolf)
    wolf.global_position = $Position2D.global_position
