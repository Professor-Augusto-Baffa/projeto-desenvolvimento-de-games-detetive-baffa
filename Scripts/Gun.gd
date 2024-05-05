extends Node2D

@onready var bullet = preload('res://Scenes/Bullet.tscn')
var flip_h = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play('idle')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite2D.flip_h = flip_h
	
	if Input.is_action_just_pressed("shoot"):
		$AnimatedSprite2D.play('shoot')
		$AudioStreamPlayer2D.play()
		var noz_pos: Vector2
		if not flip_h:
			noz_pos = $Nozzle.global_position
		else:
			noz_pos = global_position + (global_position - $Nozzle.global_position)
		get_parent().get_parent().player_bullet(noz_pos)

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == 'shoot':
		$AnimatedSprite2D.play('idle')
