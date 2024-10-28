extends RigidBody3D


var SkipFlicker := false
var Flicker := false
var FlickerAccumulator := 0.0


const RING_MIN_VEL = 5.0
const FLICKER_TIME = 2.0
const FLICKER_RATE = 0.05


const RING_SPARKLE = preload("res://effects/RingSparkle/RingSparkle.tscn")


func _physics_process(delta: float) -> void:
	if Flicker:
		FlickerAccumulator += delta
		$Coin.visible = (fmod(round(FlickerAccumulator / FLICKER_RATE), 2.0) == 0)


func SetVelocity(AdditionalSpeed: float) -> void:
	linear_velocity = Vector3(
		(randf() * 2.0 - 1.0) * 2.0, 
		randf() * 4.0 + 1.0, 
		(randf() * 2.0 - 1.0) * 2.0).normalized() * RING_MIN_VEL
	linear_velocity *= Vector3(AdditionalSpeed, 1.0, AdditionalSpeed)
	$Timer.start(randi_range(3, 6))


func EnteredLava() -> void:
	gravity_scale = 0.25
	linear_velocity = Vector3.ZERO
	SkipFlicker = true
	$Timer.start(1.0)


func _on_coin_collected(body: Variant) -> void:
	var sparkle = RING_SPARKLE.instantiate()
	get_parent().add_child(sparkle)
	sparkle.global_position = global_position
	queue_free()


func _on_timer_timeout() -> void:
	if SkipFlicker:
		queue_free()
	elif Flicker:
		queue_free()
	else:
		Flicker = true
		$Timer.start(FLICKER_TIME)
