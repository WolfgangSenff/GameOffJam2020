extends Area2D

signal killed

export (float) var Speed
export (int) var HP
export (bool) var ShouldFlipDirection = true
export (float) var Damage

var velocity = Vector2.ZERO

onready var anim = $AnimationPlayer
onready var state_machine = $StateMachine
onready var invincible_damage_state = $StateMachine/DamageStates/InvincibleTimeoutState
onready var wandering_physics_state = $StateMachine/PhysicsStates/WanderingPhysicsState
onready var sprite = $Sprite

var direction setget set_direction

func _ready() -> void:
    yield(get_tree(), "physics_frame")
    yield(get_tree(), "physics_frame")
    state_machine.current_damage_state = invincible_damage_state
    state_machine.current_physics_state = wandering_physics_state

func set_direction(value) -> void:
    if value:
        direction = value.normalized() # Just in cased
        if round(direction.x) != 0 and ShouldFlipDirection:
            sprite.scale.x = -direction.x

func begin_flashing() -> void:
    anim.play("BeginFlashing")
    
func stop_flashing() -> void:
    anim.play("Default")

func _physics_process(delta: float) -> void:
    if is_instance_valid(state_machine.current_physics_state) and state_machine.current_physics_state:
        state_machine.current_physics_state.handle_physics(delta)

func _on_WhiteSheetGhost_area_entered(area: Area2D) -> void:
    if is_instance_valid(state_machine.current_damage_state) and state_machine.current_damage_state:
        state_machine.current_damage_state.handle_damage(area, area.global_position - global_position)
    
func dies() -> void:
    emit_signal("killed")
    queue_free()
