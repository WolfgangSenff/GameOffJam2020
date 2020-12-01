extends Control

const HatchetIcon = preload("res://assets/images/hatchet_icon.png")
const CrossbowIcon = preload("res://assets/images/crossbow_icon.png")
const ShotgunIcon = preload("res://assets/images/shotgun_icon.png")
const GrenadeIcon = preload("res://assets/images/grenade_icon.png")

onready var weapon_icon_texture = $TextureRect
onready var shotgun_shell_progress = $ShotgunShellProgress

var all_weapons = []
var available_weapons = []
var current_weapon_index = 0

const ShotgunIndex = 2
const GrenadeIndex = 3

func _ready() -> void:
    available_weapons.push_back(HatchetIcon)
    all_weapons.push_back(HatchetIcon)
    all_weapons.push_back(CrossbowIcon)
    all_weapons.push_back(ShotgunIcon)
    all_weapons.push_back(GrenadeIcon)
    weapon_icon_texture.texture = available_weapons[0]

func update_gui(is_reload : bool) -> void:
    if current_weapon_index == ShotgunIndex:
        if is_reload:
            shotgun_shell_progress.value = 17
        else:
            shotgun_shell_progress.value -= 2

func gain_weapon() -> void:
    var next_weapon = available_weapons.size()
    available_weapons.push_back(all_weapons[next_weapon])
    current_weapon_index = next_weapon - 1
    swap_weapon()
    
func swap_weapon() -> void:
    current_weapon_index += 1
    if current_weapon_index >= available_weapons.size():
        current_weapon_index = 0
        
    weapon_icon_texture.texture = available_weapons[current_weapon_index]
    if current_weapon_index == ShotgunIndex:
        shotgun_shell_progress.show()
    else:
        shotgun_shell_progress.hide()
    

func _physics_process(delta: float) -> void:
    if Input.is_action_just_pressed("ui_swap_weapons"):
        swap_weapon()
