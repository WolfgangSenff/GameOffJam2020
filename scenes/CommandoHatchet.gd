extends Weapon

onready var enemy_hit_collision_shape = $EnemyHitArea/CollisionShape2D
onready var anim = $AnimationPlayer

func activate_weapon() -> void:
    pass
    
func deactivate_weapon() -> void:
    enemy_hit_collision_shape.disabled = true
    
func main_activation(_velocity : Vector2 = Vector2(0, 0)) -> void:
    anim.play("Down")

func secondary_activation(_velocity : Vector2 = Vector2(0, 0)) -> void:
    anim.play("Slash")
    
func reset_weapon() -> void:
    anim.play("Reset")
    
func go_idle() -> void:
    anim.play("Idle")
    
func is_idle() -> bool:
    return anim.current_animation == "Idle"

