extends ComplexState


var AirVel := Vector3.ZERO
var InputVel := Vector3.ZERO
var InputSpeed := 0.0

var AddPlayerInput := false


const COLLISION_INDICATOR = preload("res://entities/Collision/Collision.tscn")


func _ready() -> void:
	super()
	DebugMenu.AddMonitor(self, "AirVel")
	DebugMenu.AddMonitor(self, "InputVel")
	DebugMenu.AddMonitor(self, "InputSpeed")


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 1.0)
	
	if _msg.has("AirVel"):
		AirVel = _msg["AirVel"]
	else:
		AirVel = Vector3.ZERO
	
	if _msg.has("InputVel"):
		InputVel = _msg["InputVel"]
	else:
		InputVel = Vector3.ZERO
	
	if _msg.has("InputSpeed"):
		InputSpeed = _msg["InputSpeed"]
	else:
		InputSpeed = 0.0
	
	super(_msg)
	
	


func Exit() -> void:
	super()


func Update(_delta: float) -> void:
	UpdateInput(_delta)
	var inputVel = (InputVel * InputSpeed) if AddPlayerInput else Vector3.ZERO
	AirMove(_delta, inputVel)
	super(_delta)


func UpdateInput(_delta: float) -> void:
	InputVel += owner.Controller.InputVelocity * _delta
	if InputVel.length() > owner.PARAMETERS.JUMP_INPUT_VEL_MAX:
		InputVel = InputVel.normalized() * owner.PARAMETERS.JUMP_INPUT_VEL_MAX


func AirMove(_delta: float, additionalInput:= Vector3.ZERO) -> void:
	AirVel.y -= owner.PARAMETERS.GRAVITY * _delta * (0.5 if Input.is_action_pressed("Jump") else 1.0)
	
	var vel = AirVel + (additionalInput)
	if vel.length() > owner.PARAMETERS.AIR_MAX_SPEED:
		vel.move_toward(vel.normalized() * owner.PARAMETERS.AIR_MAX_SPEED, _delta)
	
	owner.Move(vel)


func CollisionDetection() -> SonicCollision:
	for i in range(owner.get_slide_collision_count()):
		var collision = owner.get_slide_collision(i)
		var coll = COLLISION_INDICATOR.instantiate()
		owner.get_parent().add_child(coll)
		coll.SetToCollision(collision)
		
		var dot = owner.up_direction.dot(collision.get_normal())
		if dot > owner.PARAMETERS.LAND_FLOOR_DOT_MIN:
			print("Air: Floor hit")
			return SonicCollision.new(SonicCollision.COLL_TYPE.BOTTOM, collision.get_position(), collision.get_normal())
		elif dot > owner.PARAMETERS.LAND_WALL_DOT_MIN:
			print("Air: Side hit")
			return SonicCollision.new(SonicCollision.COLL_TYPE.SIDE, collision.get_position(), collision.get_normal())
		else: #Hit ceiling
			var groundDot = owner.up_direction.dot(Vector3.UP)
			if groundDot < 0.75:
				print("Air: landed upside down")
				owner.FloorNormal = collision.get_normal()
				owner.up_direction = collision.get_normal()
				return null
			else:
				print("Air: hit ceiling? GroundDot was ", groundDot)
				return null
	return null
