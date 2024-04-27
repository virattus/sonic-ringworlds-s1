extends Character


@onready var SndPop = $SndPop


func _process(delta: float) -> void:
	pass


func ReceiveDamage(hurtbox: Area3D, damage: int) -> void:
	super(hurtbox, damage)
	if Health <= 0:
		SndPop.play()
		$StateMachine.ChangeState("Pop")
