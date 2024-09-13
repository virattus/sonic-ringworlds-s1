extends BasicState



func Enter(_msg := {}) -> void:
	owner.FightCam.Activate(true)
	owner.player.StateM.ChangeState("Idle")
	owner.boss.StateM.ChangeState("Idle")


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	pass
