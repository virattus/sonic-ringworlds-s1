extends Area3D


var Triggered := false
var Complete := false
var Speed := 0.0


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
		Triggered = true
		Speed = clamp(body.velocity.length(), 0.0, 1.0)
		$AudioStreamPlayer3D.play()



