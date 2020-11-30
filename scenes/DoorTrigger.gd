extends "res://scenes/PlayerTrigger.gd"

onready var anim = $AnimationPlayer

export (Resource) var LevelResource

func trigger_entered() -> void:
    anim.play("DoorOpen")
    yield(get_tree(), "physics_frame")
    if LevelResource:
        $LevelExit.ConnectedLevel = LevelResource
        $LevelExit.enable_exit()
