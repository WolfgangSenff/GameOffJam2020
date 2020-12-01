extends "res://scenes/LevelExit.gd"

func _ready() -> void:
    $CollisionShape2D.set_deferred("disabled", false)
