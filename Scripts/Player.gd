class_name Player
extends CharacterBody2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var COYOTE_TIME: float = 0.075
@export var GRAVITY_MULTIPLIER: float = 1.0
@export var JUMP_FORCE: float = -400.0
@export var JUMP_TIME: float = 0.0
@export var WIND_TIME: float = 0.5
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping: bool = false
var jump_timer: float = 0
var coyote_timer: float = 0
var wind_timer: float = 0
var was_on_floor: bool = true
var can_control: bool = true

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func handle_sounds():
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

func _ready():
	$AnimatedSprite2D.play('idle')

func _physics_process(delta):
	if not can_control : return
	var mouse_direction: Vector2 = get_global_mouse_position() - $Center.global_position
	sprite.flip_h = mouse_direction.x < 0
	$Gun.flip_h = mouse_direction.x < 0
	if mouse_direction.x < 0:
		mouse_direction *= -1
	var mouse_angle: float = mouse_direction.angle()
	$Gun.rotation = mouse_angle
	
	if velocity.y > 0:
		wind_timer += delta
		
		if wind_timer > WIND_TIME and not $WindPlayer.playing:
			$WindPlayer.play()
	else:
		$WindPlayer.stop()
		wind_timer = 0
	
	
	if Input.is_action_just_pressed("debug"):
		print('mouse_angle: ', mouse_angle)
	
	# Add the gravity.
	if not is_on_floor() and not is_jumping:
		velocity.y += gravity * GRAVITY_MULTIPLIER * delta
		coyote_timer += delta
		
	else:
		coyote_timer = 0

	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_timer < COYOTE_TIME or is_on_wall()):
		velocity.y = JUMP_FORCE
		sprite.play('jump')
		$StepPlayer.play()
		is_jumping = true

	elif Input.is_action_pressed('jump') and jump_timer < JUMP_TIME:
		jump_timer += delta
		
	else:
		is_jumping = false
		jump_timer = 0
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	handle_animations(direction)
	handle_sounds()
	was_on_floor = is_on_floor()
	
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
