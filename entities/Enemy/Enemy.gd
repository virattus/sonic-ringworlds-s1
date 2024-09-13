class_name Enemy
extends Character


@export var HomeMaxDist := 10.0
@export var MaxVisibility := 20.0

@onready var Home: Vector3 = global_position

@onready var StateM : StateMachine = $StateMachine
@onready var HitBox : Hitbox = $Hitbox

var EnemyActive := true
var EnemyInvincible := false
var EnemyDefeated := false

const DEFEATSOUND = preload("res://entities/Enemy/EnemyDefeatSound/EnemyDefeatSound.tscn")
const EXPLOSION = preload("res://effects/Explosion/Explosion.tscn")
const FLICKY = preload("res://entities/Flicky/Flicky.tscn")


func _ready() -> void:
	DebugMenu.AddMonitor(self, "EnemyActive")
	DebugMenu.AddMonitor(self, "EnemyInvincible")
	DebugMenu.AddMonitor(self, "EnemyDefeated")


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
	if EnemyInvincible:
		return
	
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
	EnemyDefeated = true
	StateM.ChangeState("Inactive")
	queue_free()


func SpawnDefeatSound() -> void:
	var sound = DEFEATSOUND.instantiate()
	get_parent().add_child(sound)


func SpawnExplosion() -> void:
	var explosion = EXPLOSION.instantiate()
	get_parent().add_child(explosion)
	explosion.global_position = global_position + Vector3(0, 0.5, 0)


func SpawnFlicky() -> void:
	var flicky = FLICKY.instantiate()
	get_parent().add_child(flicky)
	flicky.global_position = global_position + Vector3(0, 0.5, 0)
