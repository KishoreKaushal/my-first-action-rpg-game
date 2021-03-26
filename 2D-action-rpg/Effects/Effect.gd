extends AnimatedSprite


func _ready() -> void:
	frame = 0
	connect("animation_finished", self, "_on_animation_finished")
	play("default")


func _on_animation_finished() -> void:
	queue_free()
