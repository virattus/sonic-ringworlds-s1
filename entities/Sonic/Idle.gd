extends BasicState



func Enter(_msg := {}) -> void:
	owner.Controller.JumpJustPressed.connect(HandleJump)
	owner.Controller.AttackJustPressed.connect(HandleAttack)
	

func Exit() -> void:
	owner.Controller.JumpJustPressed.disconnect(HandleJump)
	owner.Controller.AttackJustPressed.disconnect(HandleAttack)
	

func Update(_delta: float) -> void:
	if !owner.GroundCollision:
		ChangeState("Fall")
		return
	
	#if owner.Controller.InputJump == CharController.BUTTON_JUST_PRESSED:
	#	ChangeState("Jump")
	#	return
	
	#if owner.Controller.InputAttack == CharController.BUTTON_JUST_PRESSED:
		#First, check if there's an object we can interact with
	#	if !owner.InteractHandler.Interact():
			#Okay, attack
	#		pass
	
	#Figure out how to do smashing the stick for a boost of speed, wavedashing style
	if owner.Controller.InputVelocity.length() > 0.0:
		ChangeState("Move")
		return
	
	owner.Move(Vector3.ZERO)
	owner.CharMesh.LerpMeshOrientation(owner.velocity, _delta)


func HandleJump() -> void:
	ChangeState("Jump")


func HandleAttack() -> void:
	return
