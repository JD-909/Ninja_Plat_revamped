extends Node2D

#Si el jugador sale de los player bounds, se muere y vuelve al checkpoint
func _on_player_bounds_body_entered(body: Node2D) -> void:
	if body.get_class() == "CharacterBody2D":
		body.die()
