extends Node2D

onready var anim = $AnimationPlayer

func appear():
    var spawner = get_tree().get_nodes_in_group("Spawner")[0]
    get_parent().remove_child(self)
    spawner.add_child(self)
    anim.play("Appear")
    yield(anim, "animation_finished")
    
func disappear():
    anim.play("Disappear")
    yield(anim, "animation_finished")

func open_door():
    anim.play("Open")
    yield(anim, "animation_finished")
    
func close_door():
    anim.play("Close")
    yield(anim, "animation_finished")
