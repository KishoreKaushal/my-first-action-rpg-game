extends Node2D

const GrassEffectScene : PackedScene = preload("res://Effects/GrassEffect.tscn")


func create_grass_effect() -> void:
	var grass_effect = GrassEffectScene.instance()
	get_parent().add_child(grass_effect)
	grass_effect.global_position = global_position


func _on_Hurtbox_area_entered(area: Area2D) -> void:
	create_grass_effect()
	queue_free()
