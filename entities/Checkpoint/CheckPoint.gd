extends Area3D


var Triggered := false
var Complete := false
var Speed := 0.0

const SPEED_MODIFIER = 0.25

const SPARKLE = preload("res://entities/Checkpoint/Sparkle.tscn")


func _physics_process(delta: float) -> void:
	if Complete:
		return
	
	if Triggered:
		$Pivot.rotate_z(Speed)
		Speed = lerp(Speed, 0.0, delta)
		if Speed < 0.1:
			$Pivot.rotation_degrees.z = 180.0
			Complete = true
		
		var sparkle = SPARKLE.instantiate()
		add_child(sparkle)
		sparkle.global_position = $Pivot/SpriteSpinner.global_position


func _on_body_entered(body: Node3D) -> void:
	if !Triggered:
		DeactivateOtherCheckpoints()
		Triggered = true
		body.StartingPosition = global_position + Vector3(0, 0.5, 0)
		StartCheckPointAnim(body.velocity.length())
		if Globals.RingCount >= 100:
			AddOneUp(body)


func AddOneUp(body) -> void:
	Globals.RingCount = 0
	body.CollectOneUp()


func StartCheckPointAnim(Speed: float) -> void:
	Speed = clamp(Speed * SPEED_MODIFIER, 0.25, 1.0)
	$SndCheckPointTrigger.play()


func DeactivateOtherCheckpoints() -> void:
	var cps = get_tree().get_nodes_in_group("CheckPoint")
	for i in cps:
		i.Deactivate()


func Deactivate() -> void:
	Triggered = false
	Complete = false
	$Pivot.rotation_degrees.z = 0.0
