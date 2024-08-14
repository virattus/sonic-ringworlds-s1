extends "res://entities/Enemy/Enemy.gd"


@onready var AnimPlayer: AnimationPlayer = $AnimationPlayer


func EnemyDeath() -> void:
	super()
	SpawnExplosion()
	SpawnFlicky()
	SpawnDefeatSound()
