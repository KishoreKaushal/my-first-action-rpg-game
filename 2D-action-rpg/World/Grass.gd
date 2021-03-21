extends Node2D


func create_grass_effect() -> void:
	var GrassEffectScene : PackedScene = load("res://Effects/GrassEffect.tscn")
	var grass_effect = GrassEffectScene.instance()
	var world = get_tree().current_scene
	world.add_child(grass_effect)
	grass_effect.global_position = global_position


func _on_Hurtbox_area_entered(area: Area2D) -> void:
	create_grass_effect()
	queue_free()
