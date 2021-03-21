extends Node2D


onready var animated_sprite = $AnimatedSprite


func _ready() -> void:
	animated_sprite.frame = 0
	animated_sprite.play("default")


func _on_AnimatedSprite_animation_finished() -> void:
	queue_free()
