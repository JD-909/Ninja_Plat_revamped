extends Interactible
class_name Door

@export var door_preload : String

func _on_area_2d_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file(door_preload)
