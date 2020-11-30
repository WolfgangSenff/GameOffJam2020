extends "res://scenes/Enemy.gd"

export (bool) var ShouldFlipDirection = true
export (float) var TimeBetweenShots = 3.0

onready var fire_position = $Sprite/FirePosition
onready var anim = $AnimationPlayer
onready var dam_anim = $DamageAnimationPlayer
onready var sprite = $Sprite
const FireBulletScene = preload("res://scenes/FlameBullet.tscn")

var velocity = Vector2.ZERO
var current_time_to_next_shot = 0

export (float) var Damage
export (int) var HP
export (float) var Speed

onready var damage_state = $StateMachine/DamageStates/SpecificWeaponTypeDamageState
onready var follow_state = $StateMachine/PhysicsStates/FollowTargetPhysicsState

var direction setget set_direction

func _ready() -> void:
    yield(get_tree(), "physics_frame")
    yield(get_tree(), "physics_frame")
    state_machine.current_damage_state = damage_state
    state_machine.current_physics_state = follow_state
    follow_state.target = get_tree().get_nodes_in_group("Player")[0]
    current_time_to_next_shot = TimeBetweenShots
    
func set_direction(value) -> void:
    if value:
        direction = value.normalized() # Just in cased
        if round(direction.x) != 0 and ShouldFlipDirection:
            sprite.scale.x = -direction.x

func _physics_process(delta: float) -> void:
    current_time_to_next_shot -= delta
    if is_instance_valid(self) and is_instance_valid(state_machine) and is_instance_valid(state_machine.current_physics_state) and state_machine.current_physics_state:
        state_machine.current_physics_state.handle_physics(delta)
        if state_machine.current_physics_state.is_moving:
            anim.queue("Move")
        elif state_machine.current_physics_state.is_idle:
            anim.queue("Move")
        elif state_machine.current_physics_state.is_attacking:
            if current_time_to_next_shot <= 0:
                anim.play("Fire")
                current_time_to_next_shot = TimeBetweenShots
    
func fire() -> void:
    var bullet = Projectiles.instance_bullet_on_main(FireBulletScene, fire_position.global_position, fire_position.global_rotation, $StateMachine/PhysicsStates/FollowTargetPhysicsState.MovementSpeed if state_machine.current_physics_state.is_moving else 0)
    bullet.fire("FireFlame")
    
func _on_FlameEnemy_area_entered(area: Area2D) -> void:
    if is_instance_valid(state_machine.current_damage_state) and state_machine.current_damage_state:
        state_machine.current_damage_state.handle_damage(area, area.global_position - global_position)
 
func take_damage() -> void:
    dam_anim.play("TakeDamage")
