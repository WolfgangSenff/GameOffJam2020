extends Node2D

const OozeScene = preload("res://scenes/OozeBoss.tscn")

onready var anim_sprite = $AnimatedSprite
onready var spawn_position = $Position2D

func begin_oozing() -> void:
    var spawn_in_node = get_tree().get_nodes_in_group("Spawner")[0]
    var ooze_boss = OozeScene.instance()
    anim_sprite.play("BeginOozing")
    yield(anim_sprite, "animation_finished")
    spawn_in_node.add_child(ooze_boss)
    ooze_boss.global_position = spawn_position.global_position
    anim_sprite.play("StopOozing")
    yield(anim_sprite, "animation_finished")
    
