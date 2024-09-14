extends "res://entities/Enemy/Idle.gd"



func Enter(_msg := {}) -> void:
	ChangeState("Follow")


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	pass
