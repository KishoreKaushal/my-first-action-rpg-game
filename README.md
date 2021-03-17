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

Code for calculating the input strength.

```gdscript
var input_vector := Vector2(
   Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
   Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
)
```
