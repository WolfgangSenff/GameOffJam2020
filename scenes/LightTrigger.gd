extends "res://scenes/PlayerTrigger.gd"

onready var anim = $AnimationPlayer

func trigger_entered() -> void:
    anim.play("ShowLight")
