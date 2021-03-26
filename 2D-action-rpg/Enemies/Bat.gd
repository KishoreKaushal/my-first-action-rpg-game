extends KinematicBody2D

export(float) var MAX_SPEED := 0.5
export(float) var ACCELERATION_MAGNITUDE := 10
export(float) var DEACCELERATION_MAGNITUDE := 1
export(float) var KNOCKBACK_MULTIPLIER := 3.5

const EnemyDeathEffectScene : PackedScene = preload("res://Effects/EnemyDeathEffect.tscn")

enum State {
	IDLE, 
	WANDER,
	CHASE
}

onready var animated_sprite : AnimatedSprite = $AnimatedSprite
onready var stats : Node = $Stats
onready var player_detection_zone : Area2D = $PlayerDetectionZone
onready var bat_state = State.IDLE

var knockback_velocity : Vector2 = Vector2.ZERO
var velocity : Vector2 = Vector2.ZERO


func _ready() -> void:
	print(stats.MAX_HEALTH)
	print(stats.health)


func _physics_process(dt: float) -> void:
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, ACCELERATION_MAGNITUDE * dt)
	var obj : KinematicCollision2D = move_and_collide(knockback_velocity)
	if (obj != null):
		knockback_velocity = obj.collider_velocity
	
	match bat_state:
		State.IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, DEACCELERATION_MAGNITUDE * dt)
			seek_player()
			
		State.WANDER:
			pass
		
		State.CHASE:
			var player = player_detection_zone.player
			if player != null:
				var dir_unit_vec = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(dir_unit_vec * MAX_SPEED, ACCELERATION_MAGNITUDE * dt)
			else:
				bat_state = State.IDLE
	
	animated_sprite.flip_h = velocity.x < 0
	obj = move_and_collide(velocity)
	if obj != null:
		velocity = obj.collider_velocity		


func seek_player() -> void:
	if player_detection_zone.can_see_player():
		bat_state = State.CHASE


func _on_Hurtbox_area_entered(area: Area2D) -> void:
	if area.knockback_vector:
		stats.health -= area.DAMAGE
		knockback_velocity = area.knockback_vector * KNOCKBACK_MULTIPLIER


func create_death_effect() -> void:
	var death_effect = EnemyDeathEffectScene.instance()
	get_parent().add_child(death_effect)
	death_effect.global_position = global_position


func _on_Stats_no_health() -> void:
	create_death_effect()
	queue_free()
