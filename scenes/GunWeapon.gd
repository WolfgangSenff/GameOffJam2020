extends Weapon

const BulletScene = preload("res://scenes/ShotgunBullet.tscn")

onready var shotgun_fire_position = $GunSprite/FirePosition
onready var anim = $GunAnimationPlayer

var max_bullet_count = 8
var bullet_count = 8

var velocity = Vector2.ZERO

func activate_weapon() -> void:
    pass
    
func deactivate_weapon() -> void:
    pass
    
func main_activation(_velocity : Vector2 = Vector2(0, 0)) -> void:
    if bullet_count > 0:
        bullet_count -= 1
        velocity = _velocity
        anim.play("Shoot")

func secondary_activation(_velocity : Vector2 = Vector2(0, 0)) -> void:
    bullet_count = max_bullet_count
    get_tree().call_group("WeaponChangerGUI", "update")
    velocity = _velocity
    anim.play("Cock")
    
func reset_weapon() -> void:
    anim.play("Reset")
    
func go_idle() -> void:
    anim.play("Idle")
    
func is_idle() -> bool:
    return anim.current_animation == "Idle"

func fire_gun() -> void:
    var bullet = Projectiles.instance_bullet_on_main(BulletScene, shotgun_fire_position.global_position, shotgun_fire_position.global_rotation, velocity.length())
    bullet.fire()
