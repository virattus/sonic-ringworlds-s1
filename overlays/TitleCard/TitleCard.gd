extends CanvasLayer


signal TitleCardAnimComplete

@export var Title1 : String = "test string"
@export_range(1, 2, 1) var ActNo := 1


@onready var Title1Strip = $Title1Pos/clrTitle1
@onready var Title1Label = $Title1Pos/clrTitle1/Label


func _ready() -> void:
	SetTitleNames()


func SetTitleNames() -> void:
	Title1Label.set_text(Title1)
	#Title1Label.pivot_offset.x = Title1Label.size.x


func EndAnimation() -> void:
	TitleCardAnimComplete.emit()
	visible = false


func _on_label_item_rect_changed() -> void:
	Title1Strip.position.x = -Title1Label.size.x
	Title1Strip.size.x = Title1Label.size.x
