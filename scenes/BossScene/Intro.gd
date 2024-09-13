extends BasicState




func Enter(_msg := {}) -> void:
	#ChangeState("Fight")
	
	owner.boss.PanCamera()
	
	pass


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	pass
