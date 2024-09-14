extends BasicState


const BOUNCE_VELOCITY = 2.0
const FOLLOW_SPEED = 2.5
const GRAVITY = 4.3


func Enter(_msg := {}) -> void:
	owner.EnemyInvincible = false
	
	var newVel : Vector3 = owner.velocity
	newVel.y = BOUNCE_VELOCITY
	owner.SetVelocity(newVel)


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	owner.Move()

	var newVel : Vector3 = owner.velocity * Vector3(1, 0, 1)
	
	newVel.y -= GRAVITY * _delta
	
	if newVel.y < 0.0:
		var distToGround : float = owner.global_position.distance_to(owner.GroundCast.get_collision_point())
		if distToGround <= 1.5:
			var direction : Vector3 = owner.global_position.direction_to(owner.player.global_position)
			newVel = ((direction * Vector3(1, 0, 1)).normalized() * FOLLOW_SPEED) + (Vector3.UP * BOUNCE_VELOCITY)
	
	owner.SetVelocity(newVel)
