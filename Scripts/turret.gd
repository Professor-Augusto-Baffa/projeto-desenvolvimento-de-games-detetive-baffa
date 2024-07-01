extends CharacterBody2D

var shooting: bool = false
var incapacitated: bool = false
var shoot_angle: float = 0.0
var hp: int = 10

@onready var damage_component = $DamageComponent

func death():
	$AnimatedSprite2D.play('death')
	$ExplodingComponent.explode()
	
func hurt():
	$AnimatedSprite2D.play("hurt")
	$Hit.play()
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	velocity.y = 300

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if $AnimatedSprite2D.animation == 'idle':
		match $AnimatedSprite2D.frame:
			0:
				$RayCast2D.target_position.x = 1000
				$Marker2D.position.x = 8
				shoot_angle = 0.0
			4:
				$RayCast2D.target_position.x = -1000
				$Marker2D.position.x = -8
				shoot_angle = PI
			_:
				$RayCast2D.target_position.x = 0
		
	if $RayCast2D.is_colliding() and not shooting and not incapacitated:
		shooting = true
		shoot()
		$ShootTimer.start(0.2)
		
	move_and_slide()
		
func shoot():
	$AudioStreamPlayer2D.play()
	Bullet.spawn($Marker2D.global_position, shoot_angle, get_tree().root, 5)


func _on_shoot_timer_timeout():
	shoot()
	$ReloadTimer.start(1)

func _on_reload_timer_timeout():
	shooting = false


func _on_animated_sprite_2d_animation_finished():
	print($AnimatedSprite2D.animation)
	if $AnimatedSprite2D.animation == 'hurt':
		$AnimatedSprite2D.play('idle')
		incapacitated = false
	elif $AnimatedSprite2D.animation == 'death':
		$AnimatedSprite2D.hide()
