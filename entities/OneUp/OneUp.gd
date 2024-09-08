extends "res://entities/ItemBox/ItemBox.gd"


func ActivateItemBox(source: Character) -> void:
	source.CollectOneUp()
	super(source)
