extends KinematicBody2D

export(float) var MAX_SPEED := 1
export(float) var ACCELERATION_MAGNITUDE := 10
export(float) var KNOCKBACK_MULTIPLIER := 3.5

var knockback_velocity:Vector2 = Vector2.ZERO


func _physics_process(dt: float) -> void:
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, ACCELERATION_MAGNITUDE * dt)
	var obj : KinematicCollision2D = move_and_collide(knockback_velocity)
	if (obj != null):
		knockback_velocity = obj.collider_velocity


func _on_Hurtbox_area_entered(area: Area2D) -> void:
	if area.knockback_vector:
		knockback_velocity = area.knockback_vector * KNOCKBACK_MULTIPLIER
