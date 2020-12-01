extends Area2D

signal killed

export (float) var Speed
export (int) var HP

var velocity = Vector2.ZERO

onready var anim_tree = $AnimationTree
onready var anim = anim_tree.get("parameters/playback")
onready var damage_anim = $DamageAnimationPlayer
onready var state_machine = $StateMachine
onready var damage_state = $StateMachine/DamageStates/SpecificWeaponTypeDamageState
onready var follow_target_physics_state = $StateMachine/PhysicsStates/FollowTargetPhysicsState
onready var sprite = $Sprite
onready var weapon = $Sprite/WeaponArea

var direction setget set_direction

func _ready() -> void:
    yield(get_tree(), "physics_frame")
    yield(get_tree(), "physics_frame")
    follow_target_physics_state.target = get_tree().get_nodes_in_group("Player")[0]
    state_machine.current_damage_state = damage_state
    state_machine.current_physics_state = follow_target_physics_state
    state_machine.current_physics_state.is_idle = true

func set_direction(value) -> void:
    if value:
        direction = value.normalized() # Just in cased
        var rounded_x = round(direction.x)
        if rounded_x != 0:
            anim.set("parameters/Moving/blend_position", rounded_x)
            
func _physics_process(delta: float) -> void:
    if is_instance_valid(self) and is_instance_valid(state_machine) and is_instance_valid(state_machine.current_physics_state) and state_machine.current_physics_state:
        state_machine.current_physics_state.handle_physics(delta)
        if state_machine.current_physics_state.is_moving:
            if anim.get_current_node() != "Grossify":
                anim.travel("Moving")
        elif state_machine.current_physics_state.is_idle:
            if anim.get_current_node() != "Grossify":
                anim.travel("Moving")
        elif state_machine.current_physics_state.is_attacking:
            anim.travel("Grossify")

func take_damage() -> void:
    damage_anim.queue("TakeDamage")

func _on_OozeBoss_area_entered(area: Area2D) -> void:
    if is_instance_valid(self) and is_instance_valid(state_machine) and state_machine.current_damage_state and is_instance_valid(state_machine.current_damage_state):
        state_machine.current_damage_state.handle_damage(area, area.global_position - global_position)
    
func dies() -> void:
    emit_signal("killed")
    queue_free()
