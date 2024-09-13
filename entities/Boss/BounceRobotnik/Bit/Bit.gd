extends Enemy


@onready var SpriteBit = $SpriteBit
@onready var SpritePop = $SpritePop


func _ready() -> void:
	EnemyInvincible = true
	super()


func EnemyDeath() -> void:
	EnemyDefeated = true
	StateM.ChangeState("Pop")
