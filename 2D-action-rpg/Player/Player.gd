extends KinematicBody2D


export(float) var MAX_SPEED := 2.5
export(float) var ACCELERATION_MAGNITUDE := 15
export(float) var DEACCELERATION_MAGNITUDE := 20 


enum State {
	MOVE,
	ROLL,
	ATTACK
}


var velocity = Vector2.ZERO


onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var animation_tree : AnimationTree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var player_state = State.MOVE


func _ready() -> void:
	animation_tree.active = true


func _physics_process(dt: float) -> void:
	match player_state:
		State.MOVE:
			move_state(dt)
				
		State.ROLL:
			pass
		
		State.ATTACK:
			attack_state()


func move_state(dt) -> void:
	var direction_unit_vector := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()	
		
	if direction_unit_vector != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", direction_unit_vector)
		animation_tree.set("parameters/Run/blend_position", direction_unit_vector)
		animation_tree.set("parameters/Attack/blend_position", direction_unit_vector)
		animation_state.travel("Run")
		velocity = velocity.move_toward(direction_unit_vector * MAX_SPEED, ACCELERATION_MAGNITUDE * dt)
	else:
		animation_state.travel("Idle")		
		velocity = velocity.move_toward(Vector2.ZERO, DEACCELERATION_MAGNITUDE * dt)
	
	var obj : KinematicCollision2D = move_and_collide(velocity)
	if (obj != null):
		velocity = obj.collider_velocity

	if Input.is_action_just_pressed("attack"):
		player_state = State.ATTACK


func attack_state() -> void:
	velocity = Vector2.ZERO
	animation_state.travel("Attack")


func attack_move_finished() -> void:
	player_state = State.MOVE
