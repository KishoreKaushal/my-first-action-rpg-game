extends KinematicBody2D

export(float) var MAX_SPEED := 2.5
export(float) var ACCELERATION_MAGNITUDE := 15
export(float) var DEACCELERATION_MAGNITUDE := 20 


enum State {
	IDLE_RIGHT
	RUN_RIGHT,
	IDLE_UP,
	RUN_UP,
	IDLE_LEFT,
	RUN_LEFT,
	IDLE_DOWN,
	RUN_DOWN
}


const state_to_animation : Dictionary = {
	State.IDLE_RIGHT : "idle_right",
	State.RUN_RIGHT : "run_right",
	State.IDLE_UP : "idle_up",
	State.RUN_UP : "run_up",
	State.IDLE_LEFT : "idle_left",
	State.RUN_LEFT : "run_left",
	State.IDLE_DOWN : "idle_down",
	State.RUN_DOWN : "run_down"
}


var velocity = Vector2.ZERO

onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var player_state = State.IDLE_RIGHT setget set_player_state, get_player_state

func set_player_state(movement_direction : Vector2):
	if (movement_direction.x > 0):
		player_state = State.RUN_RIGHT
	elif (movement_direction.x < 0):
		player_state = State.RUN_LEFT
	elif (movement_direction.y > 0):
		player_state = State.RUN_DOWN
	elif (movement_direction.y < 0):
		player_state = State.RUN_UP		
	else:
		player_state = State.IDLE_RIGHT


func get_player_state():
	return player_state


func _update_player_animation() -> void:
	animation_player.play(state_to_animation[player_state])


func _physics_process(dt: float) -> void:
	var direction_unit_vector := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()	
	
	self.player_state = direction_unit_vector
	
	_update_player_animation()
	
	if direction_unit_vector != Vector2.ZERO:
		velocity = velocity.move_toward(direction_unit_vector * MAX_SPEED, ACCELERATION_MAGNITUDE * dt)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, DEACCELERATION_MAGNITUDE * dt)
	
	var obj : KinematicCollision2D = move_and_collide(velocity)
	if (obj != null):
		velocity = obj.collider_velocity
