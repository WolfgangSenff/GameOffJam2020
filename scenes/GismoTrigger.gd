extends "res://scenes/PlayerTrigger.gd"

export (String) var GismoText

func trigger_entered() -> void:
    yield($CanvasLayer/GismoPopup.speak(GismoText), "completed")
