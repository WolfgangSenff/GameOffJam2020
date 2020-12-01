extends Node2D

onready var anim = $AnimationPlayer

func speak() -> void:
    anim.play("Speak")
    
func idle() -> void:
    anim.play("Idle")
    
func alert() -> void:
    anim.play("Alert")
