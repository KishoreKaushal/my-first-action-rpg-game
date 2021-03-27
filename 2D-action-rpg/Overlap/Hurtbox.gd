extends Area2D

export(bool) var SHOW_HIT_EFFECT = true
export(float) var invincibility_duration_sec = 0.5

const HitEffectScene : PackedScene = preload("res://Effects/HitEffect.tscn")
onready var timer = $Timer


var invincible : bool = false setget set_invincible


signal invincibility_started
signal invincibility_ended


func set_invincible(value : bool) -> void:
	invincible = value
	if invincible:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")


func start_invincibility() -> void:
	timer.start(invincibility_duration_sec)
	self.invincible = true


func create_hit_effect() -> void:
	if SHOW_HIT_EFFECT:
		var hit_effect = HitEffectScene.instance()
		add_child(hit_effect)
		hit_effect.global_position = global_position


func _on_Timer_timeout() -> void:
	self.invincible = false


func _on_Hurtbox_invincibility_ended() -> void:
	set_deferred("monitorable", true)


func _on_Hurtbox_invincibility_started() -> void:
	set_deferred("monitorable", false)
