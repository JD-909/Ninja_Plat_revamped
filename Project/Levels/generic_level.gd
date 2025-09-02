extends Node2D

func _ready() -> void:
	var player = Global.current_player_character.instantiate()
	$Player.add_child(player)
	player.position = $StartingPosition.position
	player.checkpoint_position = player.position

func _on_player_bounds_body_entered(body: Node2D) -> void:
	if body.get_class() == "CharacterBody2D":
		body.die()
