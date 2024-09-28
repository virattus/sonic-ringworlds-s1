extends "res://entities/ItemBox/ItemBox.gd"


@export var RingCount := 10


func ActivateItem() -> void:
	Target.CollectRing(RingCount)
