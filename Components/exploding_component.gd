extends Node2D

var explosion_targets: Array = []
@export var explosion_damage: int = 10
@export var explosion_knockback: float = 2000

func explode():
	$AnimatedSprite2D.show()
	$AnimatedSprite2D.play()
	$ExplosionSound.play()
	for body in explosion_targets.slice(1):
		if "damage_component" in body:
			body.damage_component.damage(explosion_damage)
			if "knockback_component" in body:
				body.knockback_component.knockback(global_position, explosion_knockback)

func _on_explosion_body_entered(body):
	explosion_targets.append(body)

func _on_explosion_body_exited(body):
	explosion_targets.erase(body)

func _on_animated_sprite_2d_animation_finished():
	get_parent().queue_free()
