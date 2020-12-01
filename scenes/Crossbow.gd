extends Weapon

const Arrow = preload("res://scenes/CrossBolt.tscn")

onready var fire_position = $FirePosition
onready var anim = $AnimationPlayer

var velocity = Vector2.ZERO

func activate_weapon() -> void:
    pass
    
func deactivate_weapon() -> void:
    pass
    
func main_activation(_velocity : Vector2 = Vector2(0, 0)) -> void:
    velocity = _velocity
    anim.play("Fire")

func secondary_activation(_velocity : Vector2 = Vector2(0, 0)) -> void:
    velocity = _velocity
    
func reset_weapon() -> void:
    pass
    
func go_idle() -> void:
    pass
    
func is_idle() -> bool:
    return true

func fire() -> void:
    var arrow = Projectiles.instance_bullet_on_main(Arrow, fire_position.global_position, fire_position.global_rotation, velocity.length())
    arrow.fire()
