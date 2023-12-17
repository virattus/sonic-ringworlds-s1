extends BasicState



func Enter(_msg := {}) -> void:
	$LandSound.play()
	
	if owner.Speed < owner.WALK_MAX_SPEED and owner.InputIsSkidding():
		ChangeState("SkidStop", {
			"Speed": owner.Speed * owner.LAND_SPEED_LOSS_MODIFIER
		})
	else:
		ChangeState("Move", {
			"Speed": owner.Speed * owner.LAND_SPEED_LOSS_MODIFIER
		})


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	pass

