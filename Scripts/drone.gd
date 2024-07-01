extends CharacterBody2D

@export var speed = 100
@onready var nav_agent: NavigationAgent2D = $Navigation/NavigationAgent2D
@onready var damage_component = $DamageComponent
@onready var knockback_component = $KnockbackComponent

var target_node: Node = null
var home_pos := Vector2.ZERO
var propulsion_angle: float = 0.0
var propulsion_lerp: float = 0
var exploding = false
var seeking_player = false
var explosion_targets: Array = []
var hp: int = 10
var knockback_queue: Vector2 = Vector2.ZERO
var dead = false

func hurt():
	$Hit.play()

func _ready():
	home_pos = self.global_position
	
	nav_agent.path_desired_distance = 4
	nav_agent.target_desired_distance = 12
	$Propulsion.play()
	$Body.animation = 'idle'
	$Body.play()
	
func _physics_process(delta):
	if dead:
		return
	
	if exploding:
		return
	
	if nav_agent.is_navigation_finished():
		return
		
	var axis = (nav_agent.get_next_path_position() - global_position).normalized()
	velocity = axis * speed
	
	if velocity != Vector2.ZERO:
		propulsion_lerp = clampf(propulsion_lerp + 0.1, 0, 1)
	else:
		propulsion_lerp = clampf(propulsion_lerp - 0.1, 0, 1)
		
	$Propulsion.rotation = lerpf(0.0, Vector2.DOWN.angle_to(-velocity), propulsion_lerp)
	$Body.rotation = lerpf(0.0, Vector2.LEFT.angle_to(velocity), propulsion_lerp)
	
	velocity += knockback_queue
	knockback_queue = Vector2.ZERO
	move_and_slide()
	
func recalculate_path():
	if exploding:
		return
	if target_node:
		nav_agent.target_position = target_node.global_position
		
	else:
		nav_agent.target_position = home_pos

func _on_recalculate_timer_timeout():
	if exploding:
		return
	recalculate_path()
	$Label.text = 'Recalculating...\n' + str(explosion_targets)

func _on_enter_area_entered(area):
	if exploding:
		return
	target_node = area.owner
	$Label.text = 'Entered\n' + str(explosion_targets)
	$Body.animation = 'aggro'
	seeking_player = true

func _on_exit_area_exited(area):
	if exploding:
		return
	if area.owner == target_node:
		target_node = null
	$Label.text = 'Exited\n' + str(explosion_targets)
	$Body.animation = 'idle'
	seeking_player = false


func _on_enter_body_entered(body):
	return


func _on_exit_body_exited(body):
	return

func death():
	dead = true
	$Propulsion.hide()
	$Body.hide()
	$Beep.stop()
	$ExplodingComponent.explode()
				
func _on_body_animation_finished():
	if $Body.animation == 'detonate':
		death()
		
func _on_navigation_agent_2d_target_reached():
	if exploding:
		return
	if seeking_player:
		$Beep.play()
		$Label.text = 'EXPLODING!'
		exploding = true
		$Body.animation = 'detonate'


func _on_explosion_body_entered(body):
	explosion_targets.append(body)
	

func _on_explosion_body_exited(body):
	explosion_targets.erase(body)


func _on_beep_finished():
	$Beep.pitch_scale += 0.5
	$Beep.play()
