extends CharacterFlag

func _ready() -> void:
	CharacterScene = preload("res://Scenes/PlayerCharacters/player_air.tscn")
	ElementFlagName = "Air"
