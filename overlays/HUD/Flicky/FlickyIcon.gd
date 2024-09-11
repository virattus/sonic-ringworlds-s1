extends Sprite2D


const INACTIVE_COLOUR = Color(1.0, 1.0, 1.0, 0.5)
const ACTIVE_COLOUR = Color(1.0, 1.0, 1.0, 1.0)


func Activate() -> void:
	var ShrinkTween = create_tween()
	ShrinkTween.tween_property(self, "scale:x", 0.0, 0.5)
	ShrinkTween.tween_callback(ShrunkComplete)


func ShrunkComplete() -> void:
	modulate = ACTIVE_COLOUR
	var growTween = create_tween()
	growTween.tween_property(self, "scale:x", 1.0, 0.5)
