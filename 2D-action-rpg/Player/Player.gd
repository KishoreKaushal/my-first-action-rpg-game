extends KinematicBody2D

export(float) var MAX_SPEED := 2.0
export(float) var ACCELERATION_MAGNITUDE := 10.0
export(float) var DEACCELERATION_MAGNITUDE := 15.0 

var velocity = Vector2.ZERO

func _physics_process(dt: float) -> void:
	var direction_unit_vector := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()	
	
	if direction_unit_vector != Vector2.ZERO:
		var dv := direction_unit_vector * (ACCELERATION_MAGNITUDE * dt)
		velocity += dv
		velocity = velocity.clamped(MAX_SPEED)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, DEACCELERATION_MAGNITUDE * dt)
	
	move_and_collide(velocity)
