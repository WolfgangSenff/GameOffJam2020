extends KinematicBody2D

enum State { Reset, Idle, Run }

onready var weapon_changer = $UnitSprite/WeaponChanger
onready var collision_shape = $CollisionShape2D
onready var char_anim_tree = $AnimationTree
onready var char_sprite = $UnitSprite
onready var char_anim = char_anim_tree.get("parameters/playback")

# Consider gun smash with the butt of it, only with arms
# Consider adding knife wielding, only with arms, maybe multiple swings
# "Moon's haunted." "What?!" "Moon's haunted!"

const Epsilon := 0.3
export (float) var Speed
var velocity = Vector2.ZERO

const IdleStateChangeTime = 2.0
var current_state = State.Reset
var current_state_change_time = 0.0

func _physics_process(delta: float) -> void:
    if current_state == State.Reset or current_state == State.Idle:
        current_state_change_time += delta
        if current_state != State.Idle:
            if current_state_change_time >= IdleStateChangeTime:
                current_state = State.Idle
                weapon_changer.current_weapon.go_idle()
    else:
        current_state_change_time = 0.0
    
    var main_input = Input.is_action_just_pressed("ui_main_activation")
    var secondary_input = Input.is_action_just_pressed("ui_secondary_activation")
    
    if main_input:
        weapon_changer.current_weapon.main_activation(velocity)
    elif secondary_input:
        weapon_changer.current_weapon.secondary_activation(velocity)
        
    
    var input = Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
                        Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
    
    if input.length_squared() > Epsilon:
        if weapon_changer.current_weapon.is_idle():
            weapon_changer.current_weapon.reset_weapon()
        char_anim.travel("Run")
        current_state = State.Run
        
        if input.x > 0:
            char_sprite.scale = Vector2(1, 1)
        elif input.x < 0:
            char_sprite.scale = Vector2(-1, 1)
            
        velocity = move_and_slide(Speed * Vector2.RIGHT.rotated(input.normalized().angle()))
    else:
        if current_state == State.Run:
            char_anim.travel("Reset")
            current_state = State.Reset
