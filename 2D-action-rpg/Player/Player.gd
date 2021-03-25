extends KinematicBody2D


export(float) var MAX_SPEED := 1
export(float) var ROLL_SPEED := 1.5
export(float) var ACCELERATION_MAGNITUDE := 15
export(float) var DEACCELERATION_MAGNITUDE := 20

enum State {
	MOVE,
	ROLL,
	ATTACK
}


var velocity = Vector2.ZERO
var roll_direction_unit_vector = Vector2.LEFT


onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var animation_tree : AnimationTree = $AnimationTree
onready var sword_hitbox : Area2D = $HitboxPivot/SwordHitbox

onready var animation_state = animation_tree.get("parameters/playback")
onready var player_state = State.MOVE


func _ready() -> void:
	animation_tree.active = true
	sword_hitbox.knockback_vector = roll_direction_unit_vector


func _physics_process(dt: float) -> void:
	match player_state:
		State.MOVE:
			move_state(dt)
				
		State.ROLL:
			roll_state(dt)
		
		State.ATTACK:
			attack_state(dt)


func move() -> void:
	var obj : KinematicCollision2D = move_and_collide(velocity)
	if (obj != null):
		velocity = obj.collider_velocity



func move_state(dt) -> void:
	var input_direction_unit_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()	
		
	if input_direction_unit_vector != Vector2.ZERO:
		roll_direction_unit_vector = input_direction_unit_vector
		sword_hitbox.knockback_vector = roll_direction_unit_vector
		animation_tree.set("parameters/Idle/blend_position", input_direction_unit_vector)
		animation_tree.set("parameters/Run/blend_position", input_direction_unit_vector)
		animation_tree.set("parameters/Attack/blend_position", input_direction_unit_vector)
		animation_tree.set("parameters/Roll/blend_position", input_direction_unit_vector)
		
		animation_state.travel("Run")
		velocity = velocity.move_toward(input_direction_unit_vector * MAX_SPEED, ACCELERATION_MAGNITUDE * dt)
	else:
		animation_state.travel("Idle")		
		velocity = velocity.move_toward(Vector2.ZERO, DEACCELERATION_MAGNITUDE * dt)
	
	move()

	if Input.is_action_just_pressed("roll"):
		player_state = State.ROLL
			

	if Input.is_action_just_pressed("attack"):
		player_state = State.ATTACK


func roll_state(dt) -> void:
	velocity = roll_direction_unit_vector * ROLL_SPEED
	move()
	animation_state.travel("Roll")


func attack_state(dt) -> void:
	velocity = Vector2.ZERO
	animation_state.travel("Attack")


func attack_move_finished() -> void:
	player_state = State.MOVE


func roll_animation_finished() -> void:
	player_state = State.MOVE
