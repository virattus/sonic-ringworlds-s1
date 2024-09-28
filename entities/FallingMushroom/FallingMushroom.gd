extends Area3D


var Body = null
var CapTween = null

var Fall := false


const FALL_SPEED = 8.0


func _physics_process(delta: float) -> void:
	if !Fall:
		return
	
	global_position.y -= FALL_SPEED * delta


func CapTweenDepressed() -> void:
	$Timer.start()



func _on_body_entered(body: Node3D) -> void:
	Body = body
	
	CapTween = create_tween()
	CapTween.tween_property($Cap, "position:y", -0.1, 0.1)
	CapTween.tween_callback(CapTweenDepressed)


func _on_body_exited(body: Node3D) -> void:
	if body != Body:
		return 
	
	Body = null
	
	if $Cap.position.y != 0.0:
		$Cap.position.y = 0.0


func _on_timer_timeout() -> void:
	Fall = true
	$CollisionShape3D3.set_deferred("disabled", true)
	$Cap/CharacterBody3D/CollisionShape3D2.set_deferred("disabled", true)
