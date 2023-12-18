extends Character



var Invincible := false
var InvincibilityTimer := 0.0

const PARAMETERS = preload("res://entities/Sonic/Sonic_Parameters.gd")

@onready var StMachine = $StateMachine


func _process(delta: float) -> void:
	super(delta)
	
	if Invincible:
		CharMesh.visible = (fmod(round(InvincibilityTimer / PARAMETERS.INVINCIBILITY_FLICKER_TIME), 2.0) == 0)
		InvincibilityTimer += delta
		if InvincibilityTimer >= PARAMETERS.INVINCIBILITY_TIMER_MAX:
			set_collision_layer_value(2, true)
			InvincibilityTimer = 0.0
			Invincible = false
			CharMesh.visible = true


func ReceiveDamage(damage: int) -> void:
	if Invincible:
		return
	
	super(damage)
	
	if Health > 0:
		Invincible = true
		set_collision_layer_value(2, false)
	else:
		StMachine.ChangeState("Death")


func InputIsSkidding() -> bool:
	var inputDir = velocity.normalized().dot(Controller.InputVelocity)
	if inputDir < PARAMETERS.SKID_ANGLE_MIN and Controller.InputVelocity.length() > PARAMETERS.SKID_INPUT_MIN:
		#print(inputDir)
		return true
	
	return false


func Pause() -> void:
	StMachine.ChangeState("Inactive")


func Resume() -> void:
	if StMachine.CurrentState == "Inactive":
		$StateMachine/Inactive.Resume()
