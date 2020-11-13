extends Area2D

export (float) var Speed
export (int) var HP

var velocity = Vector2.ZERO

onready var anim = $AnimationPlayer
onready var state_machine = $StateMachine
onready var invincible_damage_state = $StateMachine/DamageStates/InvincibleTimeoutState
onready var armor_damage_state = $StateMachine/DamageStates/ArmorDamageState
onready var wandering_physics_state = $StateMachine/PhysicsStates/WanderingPhysicsState

func _ready() -> void:
    yield(get_tree(), "physics_frame")
    yield(get_tree(), "physics_frame")
    state_machine.current_damage_state = armor_damage_state
    state_machine.current_physics_state = wandering_physics_state

func begin_flashing() -> void:
    anim.play("BeginFlashing")
    
func stop_flashing() -> void:
    anim.play("Default")

func _physics_process(delta: float) -> void:
    if state_machine.current_physics_state:
        state_machine.current_physics_state.handle_physics(delta)

func _on_WhiteSheetGhost_area_entered(area: Area2D) -> void:
    if state_machine.current_damage_state:
        state_machine.current_damage_state.handle_damage(area, area.global_position - global_position)
    
func dies() -> void:
    queue_free()
