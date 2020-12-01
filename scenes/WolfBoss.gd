extends Area2D

signal killed

export (float) var Speed
export (int) var HP

var velocity = Vector2.ZERO

onready var anim = $AnimationPlayer
onready var damage_anim = $DamageAnimationPlayer
onready var state_machine = $StateMachine
onready var normal_damage_state = $StateMachine/DamageStates/NormalDamageState
onready var wandering_physics_state = $StateMachine/PhysicsStates/WanderingPhysicsState
onready var follow_target_physics_state = $StateMachine/PhysicsStates/FollowTargetPhysicsState
onready var sprite = $Sprite
onready var weapon = $Sprite/WeaponArea

var direction setget set_direction

func _ready() -> void:
    yield(get_tree(), "physics_frame")
    yield(get_tree(), "physics_frame")
    follow_target_physics_state.target = get_tree().get_nodes_in_group("Player")[0]
    state_machine.current_damage_state = normal_damage_state
    state_machine.current_physics_state = wandering_physics_state
    state_machine.current_physics_state.is_idle = true

func set_direction(value) -> void:
    if value:
        direction = value.normalized() # Just in cased
        var rounded_x = round(direction.x)
        if rounded_x != 0:
            sprite.scale.x = -rounded_x
            
func _physics_process(delta: float) -> void:
    if is_instance_valid(self) and is_instance_valid(state_machine) and is_instance_valid(state_machine.current_physics_state) and state_machine.current_physics_state:
        state_machine.current_physics_state.handle_physics(delta)
        if state_machine.current_physics_state.is_moving:
            if anim.current_animation != "Walk":
                anim.play("Walk")
        elif state_machine.current_physics_state.is_idle:
            if anim.current_animation != "Idle":
                anim.play("Idle")
        elif state_machine.current_physics_state.is_attacking:
            if anim.current_animation != "Attack":
                anim.play("Attack")
                anim.queue("Idle")

func take_damage() -> void:
    damage_anim.queue("TakeDamage")

func _on_WolfBoss_area_entered(area: Area2D) -> void:
    if state_machine.current_damage_state:
        state_machine.current_damage_state.handle_damage(area, area.global_position - global_position)
    
func dies() -> void:
    GameState.hub_science_complete = true
    emit_signal("killed")
    queue_free()
