extends Area2D

export (NodePath) var TransferToPoint

func _ready() -> void:
    set_physics_process(false)

func _on_CameraTransferPoint_area_entered(area: Area2D) -> void:
    get_parent().transfer_camera_to_point(get_node(TransferToPoint).position)
