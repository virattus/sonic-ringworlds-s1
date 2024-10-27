extends AnimatedSprite3D

var BubbleAccumulator := 0.0
var BubbleEmitRate := 1.0
var AirBubbleAccumulator := 0.0
var AirBubbleEmitRate := 1.0

var WaterMaxHeight := 0.0

const BUBBLE_EMIT_MIN_RATE = 1.0
const BUBBLE_EMIT_RATE = 3.0
const AIR_BUBBLE_EMIT_MIN_RATE = 5.0
const AIR_BUBBLE_EMIT_RATE = 3.0

const AIR_BUBBLE = preload("res://entities/AirBubble/AirBubble.tscn")
const BUBBLE = preload("res://effects/Bubble/Bubble.tscn")


func _ready() -> void:
	WaterMaxHeight = $RayCast3D.get_collision_point().y
	$RayCast3D.queue_free()
	#print("Bubble Spawner: Max height %s" % WaterMaxHeight)


func _physics_process(delta: float) -> void:
	if global_position.distance_to(get_viewport().get_camera_3d().global_position) > 30.0:
		return
	
	AirBubbleAccumulator += delta
	if AirBubbleAccumulator >= AirBubbleEmitRate:
		AirBubbleAccumulator -= AirBubbleEmitRate
		AirBubbleEmitRate = (randf() * AIR_BUBBLE_EMIT_RATE) + AIR_BUBBLE_EMIT_MIN_RATE
		EmitBubble(AIR_BUBBLE.instantiate())
	else:
		BubbleAccumulator += delta
		if BubbleAccumulator >= BubbleEmitRate:
			BubbleAccumulator -= BubbleEmitRate
			BubbleEmitRate = (randf() * BUBBLE_EMIT_RATE) + BUBBLE_EMIT_MIN_RATE
			EmitBubble(BUBBLE.instantiate())


func EmitBubble(bubble) -> void:
	bubble.MaxHeight = WaterMaxHeight
	add_child(bubble)
	bubble.global_position = $SpawnPoint.global_position
