extends BasicState


var JumpVel := Vector3.ZERO
var InputVel := Vector3.ZERO
var InputSpeed := 0.0
var VerticalVelocity := 0.0

var Target : Node3D = null
var TargetPos := Vector3.ZERO
var TargetSeek := true
#We're getting a race condition where we detect and home in on an enemy that doesn't know that it's dead yet,
#but is dead by the time we start moving toward its position, so we'll keep a list of killed enemies
#that gets cleared when we call FindTarget, so there's a frame break
var InvalidTargets = [] 


func _ready() -> void:
	DebugMenu.AddMonitor(self, "Target")


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/AirSpinKick/blend_amount", 1.0)
	owner.AttackArea.monitoring = true
	
	if _msg.has("JumpVel"):
		JumpVel = _msg["JumpVel"]
	else:
		print("Fall: using current velocity")
		JumpVel = owner.velocity

	if _msg.has("InputVel"):
		InputVel = _msg["InputVel"]
	else:
		InputVel = Vector3.ZERO
	
	if _msg.has("InputSpeed"):
		InputSpeed = _msg["InputSpeed"]
	else:
		InputSpeed = 0.0
	
	
	TargetSeek = true


func Exit() -> void:
	owner.AnimTree.set("parameters/AirSpinKick/blend_amount", 0.0)
	owner.AttackArea.monitoring = false
	
	owner.FloorNormal = Vector3.UP
	owner.up_direction = Vector3.UP


func Update(_delta: float) -> void:
	var ActiveTarget := false
	
	if TargetSeek:
		if Target == null:
			if FindTarget():
				ActiveTarget = true
		else:
			ActiveTarget = true
	
	if ActiveTarget:
		if !TargetMovement(_delta):
			NoTargetMovement(_delta) #Annoying failsafe that shouldn't be triggered but will
	else:
		NoTargetMovement(_delta)
	
	owner.Move(owner.velocity)

	
	if owner.is_on_floor():
		ChangeState("Land")
		return

	#if Input.is_action_just_released("Attack"):
	#	TargetSeek = false


func FindTarget() -> bool:
	if owner.TargetArea.has_overlapping_bodies():
		var targets = owner.TargetArea.get_overlapping_bodies()
		for i in targets:
			if InvalidTargets.has(i):
				InvalidTargets.erase(i)
				continue
			if Target == null:
				Target = i
			else:
				if owner.global_position.distance_to(i.global_position) < owner.global_position.distance_to(Target.global_position):
					Target = i
		
		return true
	else:
		return false
	


func TargetMovement(_delta) -> bool:
	if !is_instance_valid(Target):
		return false
	else:
		var direction = owner.global_position.direction_to(Target.global_position).normalized()
		owner.SetVelocity(direction)
		return true


func NoTargetMovement(_delta) -> void:
	InputVel += owner.Controller.InputVelocity * _delta
	if InputVel.length() > owner.PARAMETERS.JUMP_INPUT_VEL_MAX:
		InputVel = InputVel.normalized() * owner.PARAMETERS.JUMP_INPUT_VEL_MAX
	
	var vel = JumpVel + (InputVel * InputSpeed)
	if vel.length() > owner.PARAMETERS.AIR_MAX_SPEED:
		vel.move_toward(vel.normalized() * owner.PARAMETERS.AIR_MAX_SPEED, _delta)
	
	VerticalVelocity -= owner.PARAMETERS.GRAVITY * _delta

	owner.SetVelocity((Vector3.UP * VerticalVelocity))


func AttackHit(body: Node3D) -> void:
	InvalidTargets.push_back(Target)
	Target = null
	VerticalVelocity = 1.0
	body.ReceiveDamage(owner.AttackArea, 1)
