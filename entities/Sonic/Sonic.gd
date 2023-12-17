extends Character



var Invincible := false
var InvincibilityTimer := 0.0

var HeldObject = null

const LAND_STICK_MIN_LENGTH = 0.1
const MOVE_STICK_ACCEL_LENGTH = 0.1
const MOVE_STICK_VEL_RATIO_MODIFIER = 0.3

const WALK_MAX_SPEED = 6.0
const RUN_MAX_SPEED = 13.0
const SPRINT_MAX_SPEED = 25.0
const DASH_MAX_SPEED = 10.0
const FLY_MAX_SPEED = 18.0

const WALK_ANIM_MODIFIER = 0.5
const RUN_ANIM_MODIFIER = 0.5
const SPRINT_ANIM_MODIFIER = 0.5

const MOVE_SPEED_ADD_MODIFIER = 5.0
const MOVE_SPEED_SUB_MODIFIER = -15.0

const SKID_ANGLE_MIN = -0.65
const SKID_INPUT_MIN = 0.8
const SKID_SPEED_LERP_MODIFIER = 4.0

const JUMP_POWER = 9.0
const JUMP_BUTTON_HELD_GRAVITY_MODIFIER = 0.5

const LAND_SPEED_LOSS_MODIFIER = 0.85

const MIN_FLIGHT_VEL = 1.0


const HURT_PAUSE_DURATION = 0.0
const HURT_BLINK_INTERVAL = 0.1
const HURT_VERT_VELOCITY_START = 6.0
const HURT_HORIZ_VELOCITY = 3.0

const INVINCIBILITY_TIMER_MAX = 3.0
const INVINCIBILITY_FLICKER_TIME = 0.1


@onready var StMachine = $StateMachine


func _process(delta: float) -> void:
	super(delta)
	
	if Invincible:
		CharMesh.visible = (fmod(round(InvincibilityTimer / INVINCIBILITY_FLICKER_TIME), 2.0) == 0)
		InvincibilityTimer += delta
		if InvincibilityTimer >= INVINCIBILITY_TIMER_MAX:
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
	if inputDir < SKID_ANGLE_MIN and Controller.InputVelocity.length() > SKID_INPUT_MIN:
		#print(inputDir)
		return true
	
	return false


func Pause() -> void:
	StMachine.ChangeState("Inactive")


func Resume() -> void:
	if StMachine.CurrentState == "Inactive":
		$StateMachine/Inactive.Resume()
