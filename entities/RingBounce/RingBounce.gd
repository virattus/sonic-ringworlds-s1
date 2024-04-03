extends RigidBody3D


var Flicker := false
var FlickerAccumulator := 0.0

const RING_MIN_VEL = 5.0
const FLICKER_RATE = 0.05

func _ready() -> void:
	linear_velocity = Vector3((randf() * 2.0 - 1.0) * 2.0, randf() * 4.0 + 1.0, (randf() * 2.0 - 1.0) * 2.0).normalized() * RING_MIN_VEL
	$Timer.start(randi_range(3, 6))


func _process(delta: float) -> void:
	if Flicker:
		FlickerAccumulator += delta
		$Coin.visible = (fmod(round(FlickerAccumulator / FLICKER_RATE), 2.0) == 0)


func _on_coin_collected(body: Variant) -> void:
	queue_free()


func _on_timer_timeout() -> void:
	$TimerFlicker.start()
	Flicker = true


func _on_timer_flicker_timeout() -> void:
	queue_free()
