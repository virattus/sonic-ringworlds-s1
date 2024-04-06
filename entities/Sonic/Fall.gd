extends BasicState


var CanStick := true
var UpDir := Vector3.ZERO

func Enter(_msg := {}) -> void:
	if _msg.has("UpDir"):
		UpDir = _msg["UpDir"]
	else:
		UpDir = owner.up_direction
	
	if _msg.has("CanStick"):
		CanStick = _msg["CanStick"]
	else:
		CanStick = true
	
	owner.AnimTree.set("parameters/Movement/blend_amount", 1.0)
	owner.AnimTree.set("parameters/Air/blend_amount", 0.0)


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	var vel = owner.velocity
	vel += owner.Controller.InputVelocity
	vel.y -= owner.PARAMETERS.GRAVITY * _delta * (0.5 if Input.is_action_pressed("Jump") else 1.0)
	
	owner.Move(vel)
	#owner.CharMesh.look_at(owner.global_position + owner.velocity)
	
	owner.CharGroundCast.target_position = (owner.velocity.normalized()) * owner.CharGroundCastLength
	owner.CharGroundCast.force_raycast_update()
	if owner.CharGroundCast.is_colliding():
		if owner.global_position.distance_to(owner.CharGroundCast.get_collision_point()) < owner.PARAMETERS.AIR_RAYCAST_SNAP_MAX_DIST:
			var raydot = owner.CharGroundCast.get_collision_normal().dot(owner.up_direction)
			if raydot < owner.PARAMETERS.FALL_CEILING_DOT_MIN: #Hit ceiling
				ChangeState("Pose")
				return
			elif raydot < owner.PARAMETERS.FALL_WALL_DOT_MIN: #wall hit
				ChangeState("Hurt", {
					"Bonk": true,
					"BounceDirection": owner.CharGroundCast.get_collision_normal(),
				})
				return
			#should be in range to land on
			else:
				owner.global_position = owner.CharGroundCast.get_collision_point() + (owner.CharGroundCast.get_collision_normal() * 0.5)
				ChangeState("Land", {
					"UpDir": owner.CharGroundCast.get_collision_normal()
				})
				return
	
	for i in range(owner.get_slide_collision_count()):
		var collision = owner.get_slide_collision(i)
		
	
	#We need to set the floornormal before transitioning to landing state
	#So this is disabled until I figure out how to get the ceiling's normal
	#if owner.is_on_ceiling():
	#	var groundDot = owner.FloorNormal.dot(Vector3.UP)
	#	if groundDot > 0.0: #Rising up, bonking on ceiling
	#		ChangeState("Land", {
	#			"UpDir": UpDir,
	#		})
	#	else: #falling upside down
	#		ChangeState("Land", {
	#			"UpDir": UpDir,
	#		})
	#		return
	
	if owner.is_on_wall_only():
		var wallDot = owner.velocity.normalized().dot(owner.get_wall_normal())
		if wallDot > owner.PARAMETERS.FALL_WALL_DOT_MIN:
			print("Fall: Wall collision with dot ", wallDot)
			#owner.FloorNormal = owner.get_wall_normal()
			ChangeState("Wipeout", {
				"UpDir": UpDir,
			})
			return
	
	if owner.is_on_floor():
		ChangeState("Land", {
			"UpDir": UpDir,
		})
		return

	
	if Input.is_action_just_pressed("Jump"):
		ChangeState("Airdash")
		return
