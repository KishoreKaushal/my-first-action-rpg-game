# my-first-action-rpg-game

My first action RPG game in godot.

## Chapter 1: Project Settings

1. 2D, Pixel preset -- set as default texture for imports

2. `Project Settings > Display > Window >`
   * `Size > Width = 320`
   * `Size > Height = 180`
   * `Size > Test Width = 1280`
   * `Size > Test Height = 720`
   * `Stretch > Mode = 2D`
   * `Stretch > Aspect = keep`

3. `res://World.tscn` - Create a new 2D node called `World`.
4. `Player` of type `KinematicBody2D`.
   * Create a `Sprite` with texture `res://Player/player.png`.
   * Since, the `Player.png` file contains a lot of frames we need to adjust the `animation` properties for the player sprite. Set the `hframes` property accordingly. In our case there are 60 horizontal frames.
   * Attach a script to the player node.


## Chapter 2 : Movement Physics

Code for calculating the direction unit vector.

```gdscript
var direction_unit_vector := Vector2(
   Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
   Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
).normalized()
```

Frame independent change in velocity:

```gdscript
export(float) var MAX_SPEED := 2.5
export(float) var ACCELERATION_MAGNITUDE := 10.0
export(float) var DEACCELERATION_MAGNITUDE := 15.0 

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
```

Refer Chapter 4 of https://salmanisaleh.files.wordpress.com/2019/02/fundamentals-of-physics-textbook.pdf

```
dv = a dt 

=> v = a (t2 - t1) + constant

OR 

=> final velocity = initial velocity + acceleration * delta-time
```

## Chapter 3: Collision Physics

First step is to add a `CollisionShape2D` for the movement to the player node. It should look something like this:

![movement collision shape](img/chapter3movementcollisionshape.png "movement collision shape")


## Chapter 4: Creating World Elements

1. Bush
   * `StaticBody2D`
   * `Sprite`

2. Change type of World node to ysort.

![ysort in action](img/chapter4ysortinaction.gif "ysort in action")


## Chapter 5: Player Animation Part - 1

Use of `AnimationPlayer` node. We will use sprite's hframes as key frames for the animation. 
These are 4 basic movement animations and 4 basic idle animations that is needed:

1. run_right & idle_right
2. run_left & idle_left
3. run_up & idle_up
4. run_down & idle_down

Then we will create a function called `_update_player_animation()` that will be called from `_physics_process()` after calculating the direction vector from input strength to update the animation. 

```gdscript
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
```

Here is the basic movement demo:

![basic movement](img/chapter5playerbasicmovementanimation.gif "basic movement")
