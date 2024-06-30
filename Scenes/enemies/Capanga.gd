extends Node2D
#
#const SPEED = 30
#
#var direction = 1
#var target = null
#
#@onready var ray_cast_right = $RayCastRightShot
#@onready var ray_cast_left = $RayCastLeftShot
#@onready var animated_sprite = $AnimatedSprite2D
#
## Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#$detection_zone.connect("body_entered", Callable(self, "_on_DetectionArea_body_entered"))
	#$detection_zone.connect("body_exited", Callable(self, "_on_DetectionArea_body_exited"))
#
#func _on_DetectionArea_body_entered(body):
	#if body == Player:
		#target = body
#
#func _on_DetectionArea_body_exited(body):
	#if body == target:
		#target = null
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#if ray_cast_right.is_colliding():
		#direction = -1
		#animated_sprite.flip_h = true
	#if ray_cast_left.is_colliding():
		#direction = 1
		#animated_sprite.flip_h = false
	#if target:
		#follow_target(delta)
	#else:
		#position.x += SPEED * delta * direction
#
#func follow_target(delta):
	#direction = (target.global_position - global_position).normalized()
	#position += direction * SPEED * delta
#
