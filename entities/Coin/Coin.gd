extends "res://entities/Collectible/Collectible.gd"


const RING_SPARKLE = preload("res://effects/RingSparkle/RingSparkle.tscn")

func _on_body_entered(body: Node3D) -> void:
	assert(body is Character)
	if body.CollectRing():
		super(body)
		var sparkle = RING_SPARKLE.instantiate()
		get_parent().add_child(sparkle)
		sparkle.global_position = global_position
