extends KinematicBody2D

export(float) var MAX_SPEED := 2.5
export(float) var ACCELERATION_MAGNITUDE := 15
export(float) var DEACCELERATION_MAGNITUDE := 20 

var velocity = Vector2.ZERO

func _physics_process(dt: float) -> void:
	var direction_unit_vector := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()	
	
	if direction_unit_vector != Vector2.ZERO:
		velocity = velocity.move_toward(direction_unit_vector * MAX_SPEED, ACCELERATION_MAGNITUDE * dt)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, DEACCELERATION_MAGNITUDE * dt)
	
	var obj : KinematicCollision2D = move_and_collide(velocity)
	if (obj != null):
		velocity = obj.collider_velocity
