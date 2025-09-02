extends Interactible
class_name CheckFlag

#si el jugador entra al area, camibia la posicion en la que reaparece
func _on_area_2d_body_entered(body: Node2D) -> void:
	body.checkpoint_position = position
