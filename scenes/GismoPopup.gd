extends PopupPanel

signal done_speaking

onready var text_animator = $AnimationPlayer
onready var gismo = $HSplitContainer/GismoIcon
onready var label = $HSplitContainer/RichTextLabel

func speak(text : String) -> void:
    label.percent_visible = 0
    label.text = text
    popup_centered_minsize(Vector2(180, 68))
    get_tree().paused = true
    text_animator.playback_speed = sqrt(text.length()) / 10.0
    text_animator.play("Speak")
    gismo.speak()
    yield(text_animator, "animation_finished")
    gismo.idle()
    yield(get_tree().create_timer(2.0, true), "timeout")
    hide()
    get_tree().paused = false
    emit_signal("done_speaking")
