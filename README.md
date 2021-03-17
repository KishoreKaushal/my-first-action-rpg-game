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
```

Refer Chapter 4 of https://salmanisaleh.files.wordpress.com/2019/02/fundamentals-of-physics-textbook.pdf

```
dv = a dt 

=> v = a (t2 - t1) + constant

OR 

=> final velocity = initial velocity + acceleration * delta-time
```
