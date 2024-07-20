extends Character


@export var MaxDistFromHome := 10.0
@export var MaxVisibility := 20.0

@onready var Home: Vector3 = global_position

@onready var SndDefeat : AudioStreamPlayer = $SndDefeat
@onready var StateM : StateMachine = $StateMachine


const EXPLOSION = preload("res://effects/Explosion/Explosion.tscn")
const FLICKY = preload("res://entities/Flicky/Flicky.tscn")



func _physics_process(delta: float) -> void:
	var cam = get_viewport().get_camera_3d()
	if cam.global_position.distance_to(global_position) > MaxVisibility:
		if StateM.CurrentState == "Inactive":
			CharMesh.visible = true
			StateM.ChangeState("Idle")
		else:
			StateM.ChangeState("Inactive")
			CharMesh.visible = false
			global_position = Home


func _on_hurtbox_hurtbox_activated(_Source: Hitbox, _Damage: int) -> void:
	Health -= _Damage
	if Health <= 0:
		EnemyDeath()
	




func EnemyDeath() -> void:
	StateM.ChangeState("Inactive")
	SndDefeat.play()
	var explosion = EXPLOSION.instantiate()
	get_parent().add_child(explosion)
	explosion.global_position = global_position + Vector3(0, 0.5, 0)
	var flicky = FLICKY.instantiate()
	get_parent().add_child(flicky)
	flicky.global_position = global_position + Vector3(0, 0.5, 0)
	queue_free()
