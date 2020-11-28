extends Area2D

signal trigger_tripped

func trigger_entered() -> void:
    pass

func _on_PlayerTrigger_area_entered(area: Area2D) -> void:
    trigger_entered()
    emit_signal("trigger_tripped")
