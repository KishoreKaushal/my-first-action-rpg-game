extends Node2D


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		var GrassEffectScene : PackedScene = load("res://Effects/GrassEffect.tscn")
		var grass_effect = GrassEffectScene.instance()
		var world = get_tree().current_scene
		world.add_child(grass_effect)
		grass_effect.global_position = global_position
		queue_free()
