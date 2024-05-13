class_name Bullet
extends Area2D

@export var SPEED: float = 2000

const my_scene: PackedScene = preload("res://Scenes/Bullet.tscn")

var flipped: bool

static func spawn(pos: Vector2, angle: float):
	var new_bullet: Bullet = my_scene.instantiate()
	new_bullet.global_position = pos
	new_bullet.rotation = angle
	
	return new_bullet

func _process(delta):
	position += delta * SPEED * Vector2.from_angle(rotation)

func _on_lifespan_timeout():
	queue_free()

func _on_area_entered(area):
	queue_free()

func _on_body_entered(body):
	self.hide()
	queue_free()
