extends Node

func instance_bullet_on_main(bullet_scene : PackedScene, pos : Vector2, rotat : float, temp_speed : float):
    var scene = bullet_scene.instance()
    get_tree().root.add_child(scene)
    scene.position = pos
    scene.rotation = rotat
    scene.temp_speed = temp_speed
    return scene
