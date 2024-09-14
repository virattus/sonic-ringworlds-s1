extends CanvasLayer


signal TitleCardAnimComplete

var Title1 : String = "test string"
var ActNo := 1

func _ready() -> void:
	SetTitleNames()


func SetTitleNames() -> void:
	$Title1Pos/clrTitle1/Label.text = Title1
	$Title1Pos/clrTitle1.set_position(Vector2(-$Title1Pos/clrTitle1/Label.get_rect().size.x, 0))
	$Title1Pos/clrTitle1.size.x = $Title1Pos/clrTitle1/Label.get_rect().size.x
	


func EndAnimation() -> void:
	TitleCardAnimComplete.emit()
