extends Player


var BallJump := false


@onready var SonicModel = $CharacterMesh/SonicModel
@onready var SonicBall = $CharacterMesh/SonicBall


func _ready() -> void:
	super()
	
	DebugMenu.AddMonitor(self, "BallJump")
	
	SetAfterimageBody(false)
	SetAfterimageLimbs(false)


func DisplayBody(Active: bool) -> void:
	SonicModel.visible = Active


func DisplayBall(Active: bool) -> void:
	SonicBall.visible = Active


func SetDashMode(Active: bool) -> void:
	DashMode = Active
	DashModeDrain = Active
	SetAfterimageBody(Active)
	SetAfterimageLimbs(Active)
	
	if Active:
		ActivateHitbox(true)
		DamageThreshold = Parameters.DAMAGE_THRESHOLD_STRIKEDASH
	else:
		ActivateHitbox(false)
		DamageThreshold = Parameters.DAMAGE_THRESHOLD_NORMAL


func SetAfterimageBody(Active: bool) -> void:
	$CharacterMesh/SonicModel/Armature/Skeleton3D/ba3DBody/AfterimageOrbEmitter.Active = Active


func SetAfterimageLimbs(Active: bool) -> void:
	$CharacterMesh/SonicModel/Armature/Skeleton3D/ba3DHandL/AfterimageOrbEmitter.Active = Active
	$CharacterMesh/SonicModel/Armature/Skeleton3D/ba3DHandR/AfterimageOrbEmitter.Active = Active
	$CharacterMesh/SonicModel/Armature/Skeleton3D/ba3DFootL/AfterimageOrbEmitter.Active = Active
	$CharacterMesh/SonicModel/Armature/Skeleton3D/ba3DFootR/AfterimageOrbEmitter.Active = Active
