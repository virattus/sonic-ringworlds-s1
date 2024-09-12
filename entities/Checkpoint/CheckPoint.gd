extends Node3D


@export_enum("INACTIVE", "ACTIVE", "BROKEN") var CheckpointState := "INACTIVE"

var Damage := 0
var Invulnerable := false

const SPARKLE = preload("res://entities/Checkpoint/Sparkle.tscn")




func BreakCheckpoint(body: Player) -> void:
	body.DashModeCharge = 1.0
	$SndShatter.play()
	CheckpointState = "BROKEN"
	$CheckpointGlass.visible = false
	$CheckpointGlassBroken.visible = true
	$Hurtbox/CollisionShape3D.set_deferred("disabled", true)
	$Timer.start()



func AddOneUp(body) -> void:
	Globals.RingCount = 0
	body.CollectOneUp()


func DeactivateOtherCheckpoints() -> void:
	var cps = get_tree().get_nodes_in_group("CheckPoint")
	for i in cps:
		i.Deactivate()


func _on_hurtbox_hurtbox_activated(Source: Hitbox, _Damage: int) -> void:
	if Invulnerable:
		return
		
	Damage += 1
	if Damage >= 2:
		BreakCheckpoint(Source.get_parent())
	else:
		Invulnerable = true
		$SndCrack.play()
		$Timer.start()


func _on_timer_timeout() -> void:
	if CheckpointState == "BROKEN":
		$SpritePop.visible = false
	else:
		Invulnerable = false
