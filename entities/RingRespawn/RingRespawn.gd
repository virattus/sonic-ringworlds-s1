extends Node3D


const RING = preload("res://entities/Coin/Coin.tscn")


func _ready() -> void:
	$Sprite3D.visible = false
	SpawnRing()


func SpawnRing() -> void:
	var ring = RING.instantiate()
	add_child(ring)
	ring.connect("Collected", RingCollected)


func RingCollected(_body) -> void:
	$TimerRespawn.start()


func _on_timer_respawn_timeout() -> void:
	SpawnRing()
