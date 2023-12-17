extends CanvasLayer


signal TransitionComplete


const FadeNode = preload("res://overlays/ScreenTransition/Fade/Fade.tscn")
const IrisNode = preload("res://overlays/ScreenTransition/IrisWipe/IrisWipe.tscn")

@onready var FadeLayer = $FadeLayer


func FadeOut(_length: float, _colour := Color.WHITE) -> void:
	FadeLayer.color = _colour
	FadeLayer.color.a = 0.0
	FadeLayer.visible = true
	var tween = create_tween()
	tween.tween_property(FadeLayer, "color:a", 1.0, _length)
	tween.tween_callback(FadeComplete)


func FadeComplete() -> void:
	TransitionComplete.emit()
	FadeLayer.visible = false


func FadeIn(_length: float, _colour := Color.WHITE) -> void:
	FadeLayer.color = _colour
	FadeLayer.visible = true
	var tween = create_tween()
	tween.tween_property(FadeLayer, "color:a", 0.0, _length)
	tween.tween_callback(FadeComplete)
	


func IrisWipeOut(length: float) -> void:
	var newIris = IrisNode.instantiate()
	newIris.WipeOut(length)
	add_child(newIris)
	newIris.IrisWipeComplete.connect(EmitCompleteSignal)


func IrisWipeIn(length: float) -> void:
	FadeLayer.visible = false
	var newIris = IrisNode.instantiate()
	add_child(newIris)
	newIris.WipeIn(length)
	newIris.IrisWipeComplete.connect(EmitCompleteSignal)



func EmitCompleteSignal() -> void:
	TransitionComplete.emit()
