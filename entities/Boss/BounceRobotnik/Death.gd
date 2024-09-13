extends BasicState


var ExplosionAccumulator := 0.0

const EXPLOSION = preload("res://effects/Explosion/Explosion.tscn")


func Enter(_msg := {}) -> void:
	pass


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	ExplosionAccumulator += _delta
	
	
