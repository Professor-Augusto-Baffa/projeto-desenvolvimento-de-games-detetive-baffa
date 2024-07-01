extends CharacterBody2D

var target: Node = null
var direction: Vector2 = Vector2.RIGHT
var angle: float = 0.0
var hp = 20
@onready var damage_component = $DamageComponent
var max_ammo = 4
var ammo = max_ammo
var shooting = false
var dead = false

func hurt():
	$Blood.show()
	$Blood.play()
	$Hit.play()
	$TimeBetweenShots.start(1.5)
	
func death():
	$Hit.play()
	$Arm.hide()
	dead = true
	$AnimatedSprite2D.play('death')

func _physics_process(delta):
	velocity.y = 400
	move_and_slide()
	if dead:
		return
		
	$Label.text = str(hp)
	if target:
		direction = target.global_position - global_position
		angle = Vector2.RIGHT.angle_to(direction)
		
		$Arm/Gun.flip_v = direction.x < 0
		$Arm.rotation = angle
		$Arm/Gun.offset.y = -5 * sign(direction.x)
		$AnimatedSprite2D.flip_h = direction.x < 0
		if ammo <= 0 and $Arm/Gun.animation != 'reload':
			$Arm/Gun.play('reload')
			$Arm/Reload1.play()
		
		elif $Arm/RayCast2D.is_colliding() and not shooting:
			var object = $Arm/RayCast2D.get_collider()
			if object == target and $TimeBetweenShots.time_left <= 0 and not shooting:
				$TimeBeforeShot.start()
				shooting = true
	
func _on_recalculate_timer_timeout():
	pass

func _on_aggro_area_entered(area):
	target = area.owner

func _on_reload_1_finished():
	$Arm/Reload2.play()
	
func _on_reload_2_finished():
	ammo = max_ammo
	$Arm/Gun.play('idle')

func _on_time_before_shot_timeout():
	$Arm/Gun.play('shoot')
	$Arm/GunPlayer.play()
	Bullet.spawn($Arm/Nozzle.global_position, angle, get_tree().root, 5)
	$TimeBetweenShots.start(1.0)
	ammo -= 1

func _on_time_between_shots_timeout():
	shooting = false


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == 'death':
		queue_free()


func _on_blood_animation_finished():
	$Blood.hide()
