class_name ItemBox
extends CharacterBody3D


@export var BreakOnTouch := false


@onready var ItemBoxModel = $ItemBoxClassic

const EXPLOSION = preload("res://effects/Explosion/Explosion.tscn")


func _ready() -> void:
	if BreakOnTouch:
		$CollisionShape3D.set_deferred("disabled", true)
	else:
		#$TouchHurtbox.queue_free()
		$TouchHurtbox/CollisionShape3D.set_deferred("disabled", true)


func ActivateItemBox(_source: Character) -> void:
	$SndItemBoxOpened.play()
	ItemBoxModel.visible = false
	DeactivateCollision()
	CreateExplosion()
	


func DeactivateCollision() -> void:
	$CollisionShape3D.set_deferred("disabled", true)
	$TouchHurtbox/CollisionShape3D.set_deferred("disabled", true)
	$Hurtbox/CollisionShape3D.set_deferred("disabled", true)


func CreateExplosion() -> void:
	var explosion = EXPLOSION.instantiate()
	get_parent().add_child(explosion)
	explosion.scale = Vector3.ONE * 2.5
	explosion.global_position = $ExplosionPoint.global_position


func _on_hurtbox_hurtbox_activated(_Source: Hitbox, _Damage: int) -> void:
	ActivateItemBox(_Source.get_parent())


func _on_touch_hurtbox_body_entered(body: Node3D) -> void:
	body.AttackHit($Hurtbox, 0.0)
	ActivateItemBox(body)


func _on_snd_item_box_opened_finished() -> void:
	queue_free()
