extends Node2D

var levels = [
    preload("res://scenes/levels/WarehouseWingCorridor1.tscn"),
    preload("res://scenes/levels/WarehouseWingCorridor2.tscn")
   ]

onready var current_level setget set_current_level
onready var current_level_holder = $CurrentLevel

func _ready() -> void:
    randomize()
    self.current_level = levels[0].instance()
    
    
func set_current_level(value):
    if !current_level:
        current_level = current_level_holder
    
    current_level.replace_by(value)
    current_level = value
    
