extends Node2D

onready var anim = $AnimationPlayer

func appear():
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
