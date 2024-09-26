extends CharacterBody3D


var SmokeAccumulator := 0.0

@onready var Emitters = [
	$SmokeEmitter1,
	$SmokeEmitter2,
	$SmokeEmitter3,
	$SmokeEmitter4,
]

const PUSH_MAGNITUDE = 0.01
const MAX_MAGNITUDE = 0.15

const VEL_LERP_DELTA = 5.0

const EMIT_SMOKE_DELTA = 0.6

const SMOKE = preload("res://effects/Smoke/Smoke.tscn")


func _ready() -> void:
	DebugMenu.AddMonitor(self, "velocity")


func _physics_process(delta: float) -> void:
	move_and_slide()
	velocity = lerp(velocity, Vector3.ZERO, delta * VEL_LERP_DELTA)
	#move_and_collide(velocity)

	if velocity.length() > 0.01:
		SmokeAccumulator += delta
		if SmokeAccumulator >= EMIT_SMOKE_DELTA:
			SmokeAccumulator -= EMIT_SMOKE_DELTA
			EmitSmoke()
		if !$SndBlockSlide.playing:
			$SndBlockSlide.play()
			


func Push(char: Player) -> void:
	#print("pushing")
	var initial := false
	if velocity.length() <= 0.0:
		initial = true
	
	var Direction : Vector3 = -global_position.direction_to(char.global_position)
	if abs(Direction.x) > abs(Direction.z):
		velocity.x = clamp(velocity.x + PUSH_MAGNITUDE * sign(Direction.x), -MAX_MAGNITUDE, MAX_MAGNITUDE)
	else:
		velocity.z = clamp(velocity.z + PUSH_MAGNITUDE * sign(Direction.z), -MAX_MAGNITUDE, MAX_MAGNITUDE)
	
	if initial:
		EmitSmoke()


func EmitSmoke() -> void:
	var EmitterDist = $SmokeEmitter1.global_position.direction_to(global_position).dot(velocity.normalized())
	var EmitterID = $SmokeEmitter1
	
	for i in Emitters:
		var newDist = i.global_position.direction_to(global_position).dot(velocity.normalized())
		if newDist > EmitterDist:
			EmitterDist = newDist
			EmitterID = i
	
	var smoke = SMOKE.instantiate()
	get_parent().add_child(smoke)
	smoke.global_position = EmitterID.global_position
