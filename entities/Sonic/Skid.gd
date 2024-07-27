extends BasicState



func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 1.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", 1.0)
	
	owner.SndSkid.play()


func Exit() -> void:
	owner.SndSkid.stop()


func Update(_delta: float) -> void:
	pass
 
