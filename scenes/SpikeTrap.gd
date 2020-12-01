extends Area2D

onready var sprite = $AnimatedSprite
onready var collision_shape = $CollisionShape2D
onready var hit_area_collision_shape = $HitArea/CollisionShape2D

func _on_SpikeTrap_body_entered(body: Node) -> void:
    collision_shape.disabled = true
    sprite.play("Prepare")
    yield(sprite, "animation_finished")
    hit_area_collision_shape.disabled = false
    sprite.play("Strike")
    yield(sprite, "animation_finished")
    collision_shape.disabled = false
    hit_area_collision_shape.disabled = true

func _on_HitArea_body_entered(body: Node) -> void:
    body.HP -= 5
