extends Node2D

var levels = {
    preload("res://resources/levels/SpaceLevel.tres") : preload("res://scenes/levels/SpaceLevelLeft.tscn"),
    preload("res://resources/levels/OozeLevel.tres") : preload("res://scenes/levels/OozeBossLevel.tscn"),
    preload("res://resources/levels/WarehouseWing1.tres") : preload("res://scenes/levels/WarehouseWingCorridor1.tscn"),
    preload("res://resources/levels/WarehouseWing2.tres") : preload("res://scenes/levels/WarehouseWingCorridor2.tscn")
   }

onready var current_level setget set_current_level
onready var current_level_holder = $CurrentLevel
onready var character = $YSort/Character

func _ready() -> void:
    randomize()
    self.current_level = levels[preload("res://resources/levels/WarehouseWing1.tres")].instance()
    
func set_current_level(value):
    if !current_level:
        current_level = current_level_holder
    
    call_deferred("replace_current_level", value)
    
func replace_current_level(value):
    var previous_level = current_level
    add_child_below_node(current_level, value)
    previous_level.queue_free()
    current_level = value
    character.global_position = current_level.get_node("StartPosition").global_position
    character.should_face(current_level.get_node("StartPosition").rotation)
    if current_level.has_signal("all_enemies_killed"):
        current_level.connect("all_enemies_killed", self, "on_enemies_all_killed", [], CONNECT_ONESHOT)
    if current_level.has_signal("hide_abalam"):
        current_level.connect("hide_abalam", self, "on_hide_abalam", [], CONNECT_ONESHOT)
    yield(current_level.initialize_level(), "completed")

func on_hide_abalam() -> void:
    $ParallaxBackground/EarthLayer/Sprite.hide()
    
func on_enemies_all_killed() -> void:
    current_level.enable_exit()
    
func switch_level(level_res : Resource) -> void:
    self.current_level = levels[level_res].instance()
