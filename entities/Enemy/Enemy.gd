extends Character


@export var MaxDistFromHome := 10.0
@export var MaxVisibility := 20.0

@onready var Home: Vector3 = global_position

@onready var SndDefeat : AudioStreamPlayer = $SndDefeat
@onready var StateM : StateMachine = $StateMachine
@onready var HitBox : Hitbox = $Hitbox

var EnemyActive := true

const EXPLOSION = preload("res://effects/Explosion/Explosion.tscn")
const FLICKY = preload("res://entities/Flicky/Flicky.tscn")


func _ready() -> void:
	DebugMenu.AddMonitor(self, "EnemyActive")


func _physics_process(delta: float) -> void:
	var cam = get_viewport().get_camera_3d()
	if cam.global_position.distance_to(global_position) > MaxVisibility:
		if StateM.CurrentState != "Inactive":
			StateM.ChangeState("Inactive")
			EnemyActivate(false)
			global_position = Home
	else:
		if StateM.CurrentState == "Inactive":
			EnemyActivate(true)
			StateM.ChangeState("Idle")


func _on_hurtbox_hurtbox_activated(_Source: Hitbox, _Damage: int) -> void:
	Health -= _Damage
	if Health <= 0:
		EnemyDeath()
	


func EnemyActivate(Active: bool) -> void:
	CharMesh.visible = Active
	SpotShadow.visible = Active
	HurtBox.monitoring = Active
	HurtBox.monitorable = Active
	HitBox.monitoring = Active
	HitBox.monitorable = Active
	EnemyActive = Active


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
