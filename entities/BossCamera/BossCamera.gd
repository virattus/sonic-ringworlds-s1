extends GameCamera


@export var player : Character
@export var boss : Character


func _ready() -> void:
	assert(player)
	assert(boss)


func _physics_process(delta: float) -> void:
	Mario64Update(delta)
	pass
	

func Mario64Update(delta: float) -> void:
	var PlayerPos : Vector3 = player.global_position
	var BossPos : Vector3 = boss.global_position
	
	var Midpoint : Vector3 = (PlayerPos + BossPos) / 2.0
	var Distance : float = PlayerPos.distance_to(BossPos)
	
	global_position =  Midpoint
	
	$SpringArm3D.spring_length = clamp(Distance, 0.1, 10.0)
	$SpringArm3D.rotation.y = PlayerPos.angle_to(BossPos)
	$SpringArm3D.position.y = clamp(Distance, 1.0, 10.0)
	$CameraTarget.global_position = Midpoint
	
	Cam.look_at(Midpoint)
	

func SonicXtremeUpdate(delta: float) -> void:
	pass
