extends Area2D

signal killed

onready var collision_shape = $CollisionShape2D
onready var state_machine = $StateMachine

func dies() -> void:
    emit_signal("killed")
    queue_free()
