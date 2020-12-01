extends KinematicBody2D

signal hp_changed(new_value)
signal died()

enum State { Reset, Idle, Run }

onready var weapon_changer = $UnitSprite/WeaponChanger
onready var collision_shape = $CollisionShape2D
onready var char_anim_tree = $AnimationTree
onready var char_sprite = $UnitSprite
onready var char_anim = char_anim_tree.get("parameters/playback")
onready var damage_timer = $DamageTimer
onready var weapon_changer_ui = $PlayerGUI/MarginContainer/Control/WeaponChangerGUI
onready var gui = $PlayerGUI/MarginContainer


# Consider gun smash with the butt of it, only with arms
# Consider adding knife wielding, only with arms, maybe multiple swings
# "Moon's haunted." "What?!" "Moon's haunted!"

const Epsilon := 0.3
export (float) var Speed
var velocity = Vector2.ZERO
var current_armor = 0
var HP = 100 setget set_hp
const BaseScale = 1

const IdleStateChangeTime = 2.0
var current_state = State.Reset
var current_state_change_time = 0.0

func _ready() -> void:
    char_sprite.scale = char_sprite.scale * BaseScale

func should_face(_rotation : float) -> void:
    if _rotation > deg2rad(90) and _rotation < deg2rad(270):
        Input.action_press("ui_left")
        yield(get_tree(), "physics_frame")
        yield(get_tree(), "physics_frame")
        Input.action_release("ui_left")

func give_next_weapon() -> void:
    weapon_changer.give_next_weapon()
    weapon_changer_ui.gain_weapon()

func hide_gui() -> void:
    gui.hide()
    
func show_gui() -> void:
    gui.show()

func set_hp(value) -> void:
    if value > 0:
        HP = value
        emit_signal("hp_changed", HP)
        $PlayerGUI/MarginContainer/Control/HealthProgress.value = HP
    else:
        emit_signal("died")

func take_damage(weapon) -> void:
    if damage_timer.is_stopped():
        damage_timer.start()
        var weapon_type = weapon.WeaponType
        var amount = weapon.Damage
        
        if current_armor > 0:
            if weapon_type == Weapon.Explosive:
                self.HP -= amount / 1.1 # Armor doesn't help much
            elif weapon_type == Weapon.Gun:
                self.HP -= amount / 1.2
            elif weapon_type == Weapon.Blade:
                self.HP -= amount / 1.5
            elif weapon_type == Weapon.Fist:
                self.HP -= amount / 2.0
        else:
            self.HP -= amount

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
            char_sprite.scale = Vector2(1, 1) * BaseScale
        elif input.x < 0:
            char_sprite.scale = Vector2(-1, 1) * BaseScale
            
        velocity = move_and_slide(Speed * Vector2.RIGHT.rotated(input.normalized().angle()))
    else:
        if current_state == State.Run:
            char_anim.travel("Reset")
            current_state = State.Reset

func _on_PlayerHitbox_area_entered(area: Area2D) -> void:
    take_damage(area)
