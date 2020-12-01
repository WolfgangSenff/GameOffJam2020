extends "res://scenes/DoorTrigger.gd"

func _ready():
    $GismoTrigger.set_physics_process(false)

func trigger_entered() -> void:
    anim.play("DoorOpen")
    yield(get_tree(), "physics_frame")
    $GismoTrigger.call_deferred("set_physics_process", true)
