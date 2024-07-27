extends "res://entities/Sonic/MoveGround.gd"



func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 1.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", -1.0)
	UpdateAnim()


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	pass


func UpdateAnim() -> void:
	if owner.Speed > owner.PARAMETERS.RUN_MAX_SPEED:
		owner.AnimTree.set("parameters/Run/blend_amount", 1.0)
		owner.AnimTree.set("parameters/TSSprint/scale", owner.Speed * owner.PARAMETERS.MOVE_SPRINT_ANIM_SPEED_MODIFIER)
	else:
		owner.AnimTree.set("parameters/Run/blend_amount", 0.0)
		owner.AnimTree.set("parameters/TSRun/scale", owner.Speed * owner.PARAMETERS.MOVE_RUN_ANIM_SPEED_MODIFIER)
