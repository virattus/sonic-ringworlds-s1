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


func ActivateItem():
	var shieldstate = Player.SHIELD.NORMAL_SHIELD
	
	match ShieldType:
		"NORMAL":
			$SndNormalShield.play()
		"FIRE":
			$SndFireShield.play()
			shieldstate = Player.SHIELD.FIRE_SHIELD
		"WATER":
			$SndWaterShield.play()
			shieldstate = Player.SHIELD.WATER_SHIELD
		"THUNDER":
			$SndThunderShield.play()
			shieldstate = Player.SHIELD.THUNDER_SHIELD
	
	Target.SetShieldState(shieldstate)
