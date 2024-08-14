extends "res://entities/Enemy/Enemy.gd"


@onready var SpritePop = $SpritePop

@onready var SndPop = $SndPop


func _ready() -> void:
	pass


func _on_hurtbox_hurtbox_activated(Source: Hitbox, Damage: int) -> void:
	super(Source, Damage)
	if Health <= 0:
		SndPop.play()
		$StateMachine.ChangeState("Pop")
		
