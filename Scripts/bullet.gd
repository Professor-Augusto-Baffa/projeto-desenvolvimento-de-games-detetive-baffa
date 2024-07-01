class_name Bullet
extends Area2D

var SPEED: float = 4000

const bullet: PackedScene = preload("res://Scenes/Bullet.tscn")

var flipped: bool
var damage: int

static func spawn(pos: Vector2, angle: float, scene: Node, damage: int):
	var new_bullet: Bullet = bullet.instantiate()
	scene.add_child(new_bullet)
	
	new_bullet.global_position = pos
	new_bullet.rotation = angle
	new_bullet.damage = damage
	
	return new_bullet

func _physics_process(delta):
	position += delta * SPEED * Vector2.from_angle(rotation)

func _on_lifespan_timeout():
	queue_free()

func _on_body_entered(body):
	if 'damage_component' in body:
		body.damage_component.damage(damage)
	
	elif 'damage' in body:
		body.damage(damage)
	
	if 'knockback_component' in body:
		body.knockback_component.knockback(global_position, 1000)
	queue_free()
