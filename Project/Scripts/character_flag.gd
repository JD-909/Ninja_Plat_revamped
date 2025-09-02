extends Interactible
class_name CharacterFlag

var CharacterScene : Resource
var ElementFlagName : String

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.element_name != ElementFlagName:
		var CharacterInstance = CharacterScene.instantiate()
		get_parent().get_parent().get_node("Player").add_child(CharacterInstance)
		CharacterInstance.position = body.position
		CharacterInstance.velocity = body.velocity
		CharacterInstance.checkpoint_position = body.checkpoint_position
		body.queue_free()
		Global.current_player_character = CharacterScene
