extends "res://scenes/LevelBase.gd"

onready var ship_anim = $ShipAnimationPlayer
onready var intro_anim = $CanvasLayer/AnimationPlayer

func initialize_level() -> void:
    get_tree().call_group("World", "hide_background")
    get_tree().call_group("Player", "set_physics_process", false)
    get_tree().call_group("Player", "hide")
    get_tree().call_group("Player", "hide_gui")
    yield(ship_anim, "animation_finished")
    get_tree().call_group("Player", "show")
    intro_anim.play("Default")
    yield(intro_anim, "animation_finished")
    
func _on_TextureButton_pressed() -> void:
    intro_anim.play("HideAll")
    yield(intro_anim, "animation_finished")
    get_tree().call_group("Player", "show_gui")
    get_tree().call_group("Player", "set_physics_process", true)
    enable_exit()
    get_tree().call_group("World", "show_background")
