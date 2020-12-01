extends Area2D

onready var sprite = $AnimatedSprite

export (float) var Speed
export (float) var Damage
export (String, "Explosive", "Gun", "Blade", "Fist") var WeaponType

var temp_speed = 0.0

func _physics_process(delta: float) -> void:
    position += Speed * Vector2.RIGHT.rotated(rotation) * delta

func fire(animation : String = "Fire") -> void:
    var movement_speed = Speed
    Speed = temp_speed
    sprite.play(animation)
    yield(sprite, "animation_finished")
    set_physics_process(true)
    Speed = movement_speed

