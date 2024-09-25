extends "res://entities/ItemBox/ItemBox.gd"


@export_enum("NORMAL", "FIRE", "WATER", "THUNDER") var ShieldType = "NORMAL"


func _ready() -> void:
	var IconRect := Rect2(32, 32, 16, 16)
	
	match ShieldType:
		"FIRE":
			IconRect = Rect2(32, 0, 16, 16)
		"WATER":
			IconRect = Rect2(0, 16, 16, 16)
		"THUNDER":
			IconRect = Rect2(16, 0, 16, 16)
			
	$ItemBoxClassic/SpriteIcon.region_rect = IconRect


func ActivateItemBox(source: Character) -> void:
	var shieldstate = Player.SHIELD.NORMAL_SHIELD
	
	match ShieldType:
		"FIRE":
			shieldstate = Player.SHIELD.FIRE_SHIELD
		"WATER":
			shieldstate = Player.SHIELD.WATER_SHIELD
		"THUNDER":
			shieldstate = Player.SHIELD.THUNDER_SHIELD
	
	source.SetShieldState(shieldstate)

	super(source)
