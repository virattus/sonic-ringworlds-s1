extends GameCamera


@export var player : Character
@export var boss : Character


func _ready() -> void:
	assert(player)
	assert(boss)
	
	DebugMenu.AddMonitor(self, "global_position")
	DebugMenu.AddMonitor($SpringArm3D, "global_position")
	DebugMenu.AddMonitor($SpringArm3D/Camera3D, "global_position")


func _physics_process(delta: float) -> void:
	#Mario64Update(delta)
	SonicXtremeUpdate(delta)
	pass
	


func Activate(Active: bool) -> void:
	Cam.current = Active


func Mario64Update(delta: float) -> void:
	var PlayerPos : Vector3 = player.global_position * Vector3(1, 0, 1)
	var BossPos : Vector3 = boss.global_position * Vector3(1, 0, 1)
	
	var Midpoint : Vector3 = (PlayerPos + BossPos) / 2.0
	var Distance : float = PlayerPos.distance_to(BossPos)
	
	global_position =  Midpoint + (Vector3.UP * maxf(player.global_position.y, boss.global_position.y))
	
	$SpringArm3D.spring_length = clamp(Distance, 3.0, 8.0)
	$SpringArm3D.rotation.y = PlayerPos.angle_to(BossPos)
	$SpringArm3D.position.y = clamp(Distance, 5.0, 10.0)
	$CameraTarget.global_position = Midpoint
	
	Cam.look_at(Midpoint)
	

func SonicXtremeUpdate(delta: float) -> void:
	var PlayerPos : Vector3 = player.global_position
	
	global_position = Vector3.ZERO + Vector3(0, 0, 0)
	
	var newPos = PlayerPos - global_position
	
	$SpringArm3D.global_position = (newPos + (newPos.normalized() * 2.5)) + (Vector3.UP * 1.0)
	$SpringArm3D/Camera3D.look_at(global_position)
	#$SpringArm3D.rotation.y = (PlayerPos * Vector3(1, 0, 1)).angle_to(global_position * Vector3(1, 0, 1))
	#$SpringArm3D.spring_length = (PlayerPos * Vector3(1, 0, 1)).distance_to(global_position * Vector3(1, 0, 1))
	#$SpringArm3D/Camera3D.position.y = to_local(PlayerPos).y
	
	
