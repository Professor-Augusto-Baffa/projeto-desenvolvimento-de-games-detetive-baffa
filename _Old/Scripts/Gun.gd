extends Node2D

@onready var bullet = preload('res://Scenes/Bullet.tscn')
@onready var player = get_parent()

var flip_h = false

func _ready():
	$AnimatedSprite2D.play('idle')

func _process(delta):
	$AnimatedSprite2D.flip_h = flip_h
	$Nozzle.position = player.mouse_direction
	if Input.is_action_just_pressed("shoot"):
		$AnimatedSprite2D.play('shoot')
		$AudioStreamPlayer2D.play()
		
		player._boost(player.mouse_direction)

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == 'shoot':
		$AnimatedSprite2D.play('idle')
