class_name Player
extends CharacterBody2D

@export var SPEED = 300.0
@export var COYOTE_TIME: float = 0.075
@export var GRAVITY_MULTIPLIER: float = 1.0
@export var JUMP_FORCE: float = -1000.0
@export var JUMP_TIME: float = 0.0
@export var WIND_TIME: float = 0.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 50000
var is_jumping: bool = false
var jump_timer: float = 0
var coyote_timer: float = 0
var wind_timer: float = 0
var was_on_floor: bool = true
var can_control: bool = true
var mouse_direction: Vector2 = Vector2(1, 0)
var mouse_angle: float = 0
var do_boost = false
var prev_velocity = Vector2.ZERO
var velocity_boost : Vector2 = Vector2.ZERO

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func handle_step_sfx():
	if sprite.animation == 'run' and sprite.frame == 0:
		$StepPlayer.play()

func handle_animations(direction: float):
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
	velocity = Vector2.ZERO
	# Add the gravity.
	if not is_on_floor() and not is_jumping:
		velocity.y += gravity * GRAVITY_MULTIPLIER * delta
		coyote_timer += delta
		
	else:
		coyote_timer = 0

	# Handle jump
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_timer < COYOTE_TIME or is_on_wall()):
		velocity.y = JUMP_FORCE
		sprite.play('jump')
		$StepPlayer.play()
		is_jumping = true


	elif Input.is_action_pressed('jump') and jump_timer < JUMP_TIME:
		jump_timer += delta
		velocity.y = JUMP_FORCE
		
	else:
		is_jumping = false
		jump_timer = 0
		

	# Handle walking
	if direction:
		velocity.x = direction * SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func _ready():
	$AnimatedSprite2D.play('idle')

func _physics_process(delta: float):
	if not can_control:
		return
	
	mouse_direction = (get_global_mouse_position() - $Center.global_position).normalized()
	mouse_angle = mouse_direction.angle()
	
	var is_mouse_facing_left: bool = mouse_direction.x < 0
	sprite.flip_h = is_mouse_facing_left
	
	$Gun.flip_h = is_mouse_facing_left
	
	if is_mouse_facing_left:
		$Gun.rotation = (-1 * mouse_direction).angle()
	else:
		$Gun.rotation = mouse_angle
	
	var direction = Input.get_axis("left", "right")
	handle_movement(delta, direction)
	handle_animations(direction)
	
	handle_step_sfx()
	handle_wind_sfx(delta)
	
	was_on_floor = is_on_floor()
	
	velocity += velocity_boost
	velocity_boost = lerp(velocity_boost, Vector2.ZERO, 0.1)
	move_and_slide()
	

func _on_porta_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	pass # Replace with function body.


func handle_danger() -> void:
	print("Player Died")
	visible = false
	can_control = false
	
	await get_tree().create_timer(1).timeout
	reset_player()
	

func reset_player():
	LevelManager.load_level(1)
	visible = true
	can_control = true


func _boost(pos: Vector2) -> void:
	velocity_boost = 500 * mouse_direction
