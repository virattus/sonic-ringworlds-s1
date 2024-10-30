class_name Boss
extends Enemy


signal CameraPanComplete


@onready var BitSpawnSequence = [
	$BitParent/RobotnikBit2,
	$BitParent/RobotnikBit4,
	$BitParent/RobotnikBit6,
	$BitParent/RobotnikBit8,
	$BitParent/RobotnikBit,
	$BitParent/RobotnikBit3,
	$BitParent/RobotnikBit5,
	$BitParent/RobotnikBit7,
]
var BitSpawnID := 0

var SpawnedBits = []

@onready var BitParent = $BitParent
@onready var HitTimer = $HitTimer


func _ready() -> void:
	DebugMenu.AddMonitor(self, "BitSpawnID")


func PanCamera() -> void:
	$CameraPivot/Camera3D.current = true
	var tween = create_tween()
	tween.tween_property($CameraPivot, "rotation:y", 1.6, 3.0)
	tween.tween_callback( func(): CameraPanComplete.emit() )


func EnemyDeath() -> void:
	StateM.ChangeState("Death")
	EnemyDefeated = true


func _on_hurtbox_hurtbox_activated(SourcePos: Vector3, Damage: int) -> void:
	super(SourcePos, Damage)
	
	HitTimer.start()
	EnemyInvincible = true
	
	var bit = null
	while bit == null:
		bit = BitSpawnSequence[BitSpawnID]
		BitSpawnID += 1
		if BitSpawnID >= 8:
			break
	
	if bit == null:
		return
	
	print("BounceRobotnik: spawning bit id: %s" % BitSpawnID)
	BitParent.remove_child(bit)
	bit.player = Globals.PlayerChar
	bit.boss = self
	get_parent().add_child(bit)
	
	bit.StateM.ChangeState("Follow")
	
	SpawnedBits.append(bit)


func _on_hit_timer_timeout() -> void:
	EnemyInvincible = false
