extends CanvasLayer


signal FadeComplete(FadeIn)

@export var FadeAlpha := 0.0

var FadeTypeFadeIn := true
var FadeTime := 1.0


@onready var FadeLayer = $FadeLayer
@onready var FadeTimer = $FadeTimer


func _process(_delta: float) -> void:
	FadeAlpha = FadeTimer.time_left / FadeTime
	
	var FadeColourAlpha: float = FadeAlpha
	
	if FadeTypeFadeIn:
		FadeColourAlpha = 1.0 - FadeAlpha

	FadeLayer.color.a = FadeColourAlpha


func FadeIn(fadeTime: float) -> void:
	Fade(fadeTime, false)


func FadeOut(fadeTime: float) -> void:
	Fade(fadeTime, true)


func FadeColour(colour: Color) -> void:
	FadeLayer.color = colour


func Fade(fadeTime: float, fadeIn: bool) -> void:
	FadeTypeFadeIn = fadeIn
	FadeTime = fadeTime
	FadeAlpha = 0.0
	FadeTimer.wait_time = fadeTime
	FadeTimer.start()


func _on_fade_timer_timeout() -> void:
	emit_signal("FadeComplete", FadeTypeFadeIn)
