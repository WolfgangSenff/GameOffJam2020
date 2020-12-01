extends ViewportContainer

onready var gismo = $GismoRoot

func speak() -> void:
    gismo.speak()
    
func idle() -> void:
    gismo.idle()
    
func alert() -> void:
    gismo.alert()
