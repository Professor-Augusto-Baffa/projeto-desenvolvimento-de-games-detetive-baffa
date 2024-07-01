extends CharacterBody2D

var ignore_collision

# MOVEMENT
var move_speed: float = 200
var jump_force: float = 400
var walk_force: float = 3000
var shoot_force: float = 400
var gravity_force: float = 20
var drag_force: float = 0

var acceleration: Vector2 = Vector2.ZERO

var is_jumping: bool = false
var jump_timer: float = 0
var coyote_timer: float = 0
var wind_timer: float = 0
var was_on_floor: bool = true
var COYOTE_TIME: float = 0.075
var JUMP_TIME: float = 0.0
var WIND_TIME: float = 0.5

# NODES
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var bullet := $Bullet
@onready var damage_component := $DamageComponent

# STATS
@export var hp: int = 30
var ammo = 5
var total_ammo = 30

# AUX
#var flash: bool = false
var knockback_queue: Vector2 = Vector2.ZERO
@onready var knockback_component = $KnockbackComponent

func flash(do_flash: bool) -> void:
	material.set_shader_parameter("active", do_flash)

'''
func knockback(origin: Vector2, ammount: float) -> void:
	acceleration += (global_position - origin) * ammount
'''
func death():
	get_tree().reload_current_scene()

func hurt():
	#$ImmunityTimer.start()
	$Blood.show()
	$Blood.play()
	$Label.text = "OUCH!"

func handle_step_sfx():
	if sprite.animation == 'run' and sprite.frame == 0:
		$StepPlayer.play()

func handle_animations(direction: float):
	sprite.flip_h = $Arm._mouse_direction.x < 0
	
	if abs(direction) > 0.1 and is_on_floor():
		sprite.play('run', 1.0, direction < 0)
		
	elif not is_on_floor():
		if was_on_floor:
			sprite.play('jump')
			
	elif not was_on_floor:
		sprite.play('land')
		$StepPlayer.play()
		
	else:
		sprite.play('idle')

func handle_wind_sfx (delta: float) -> void:
	if velocity.y > 0:
		wind_timer += delta
		
		if wind_timer > WIND_TIME and not $WindPlayer.playing:
			$WindPlayer.play()

	else:
		$WindPlayer.stop()
		wind_timer = 0

func handle_movement (delta: float, direction: float) -> void:
	acceleration = Vector2.ZERO
	
	if not is_on_floor() and not is_jumping:
		acceleration.y = gravity_force
		coyote_timer += delta
		
	else:
		coyote_timer = 0

	# Handle jump
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_timer < COYOTE_TIME or is_on_wall()):
		acceleration.y = -jump_force
		sprite.play('jump')
		$StepPlayer.play()
		is_jumping = true


	elif Input.is_action_pressed('jump') and jump_timer < JUMP_TIME:
		jump_timer += delta
		acceleration.y = -jump_force
		
	else:
		is_jumping = false
		jump_timer = 0

	if direction:
		velocity.x = direction * move_speed
		
	elif is_on_floor():
		var prev_vel_s = sign(velocity.x)
		velocity.x -= prev_vel_s * move_speed * 0.5
		if sign(velocity.x) != prev_vel_s:
			velocity.x = 0
	
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.1)
	
	if Input.is_action_just_pressed("shoot") and $Arm/Gun.animation != "reload":
		if $Arm.ammo > 0:
			acceleration -= $Arm._mouse_direction * shoot_force
			$Arm.shoot()
			#Bullet.spawn($Arm/Mouse.global_position, $Arm._mouse_angle, get_parent())
		else:
			$Arm/Empty.play()
			
	if Input.is_action_just_pressed("reload"):
		$Arm.reload()
	 
	velocity += acceleration
	
	$Label.text = 'HP: ' + str(hp) + '\nAmmo: ' + str($Arm.ammo) + ' (' + str(total_ammo) + ')'

	
func _physics_process(delta):
	if Input.is_action_just_pressed("debug"):
		#knockback_queue += (global_position - get_global_mouse_position()).normalized() * 1000
		pass
	
	var direction = Input.get_axis("left", "right")
	#sprite.material.set_shader_parameter("active", flash)
	handle_movement(delta, direction)
	handle_animations(direction)
	handle_step_sfx()
	handle_wind_sfx(delta)
	was_on_floor = is_on_floor()
	velocity += knockback_queue
	knockback_queue = Vector2.ZERO
	move_and_slide()


func _on_hitflash_timer_timeout():
	return
	'''
	if $ImmunityTimer.time_left > 0:
		flash = !flash
	else:
		flash = false
	'''	


func _on_blood_animation_finished():
	$Blood.hide()
