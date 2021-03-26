extends Area2D

export(bool) var SHOW_HIT_EFFECT = true

const HitEffectScene : PackedScene = preload("res://Effects/HitEffect.tscn")


func create_hit_effect() -> void:
	var hit_effect = HitEffectScene.instance()
	add_child(hit_effect)
	hit_effect.global_position = global_position


func _on_Hurtbox_area_entered(area: Area2D) -> void:
	if SHOW_HIT_EFFECT:
		create_hit_effect()
