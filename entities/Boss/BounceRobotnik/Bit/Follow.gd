extends BasicState



func Enter(_msg := {}) -> void:
	owner.EnemyInvincible = false


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	owner.Move()
	
	var direction = owner.global_position.direction_to(owner.player.global_position)
	
	owner.SetVelocity(direction.normalized())
