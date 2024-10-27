extends AnimatedSprite2D


const OFFSET = Vector2(50.0, -50.0)


func MoveTo(pos: Vector2) -> void:
	position = pos + OFFSET


func PlayAnim(status: bool) -> void:
	if status:
		visible = true
		play("default")
	else:
		visible = false
		stop()
