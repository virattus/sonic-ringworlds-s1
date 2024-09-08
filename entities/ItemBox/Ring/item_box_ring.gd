extends "res://entities/ItemBox/ItemBox.gd"


@export var RingCount := 10


func ActivateItemBox(source: Character) -> void:
	source.CollectRing(RingCount)
	super(source)
