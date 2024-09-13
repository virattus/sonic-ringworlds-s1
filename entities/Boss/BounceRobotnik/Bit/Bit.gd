extends Enemy


var player : Node3D
var boss : Node3D


@onready var SpriteBit = $SpriteBit
@onready var SpritePop = $SpritePop


func _ready() -> void:
	EnemyInvincible = true
	super()


func EnemyDeath() -> void:
	EnemyDefeated = true
	StateM.ChangeState("Pop")


func _on_hitbox_hitbox_activated(Target: Hurtbox) -> void:
	StateM.ChangeState("Pop")
