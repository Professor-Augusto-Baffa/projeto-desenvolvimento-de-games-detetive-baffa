extends Marker2D

var _mouse_direction: Vector2 = Vector2.ZERO
var _mouse_angle: float = 0
var flip_h = false
var ammo = 10

func _ready():
	$Gun.play('idle')
	
func _physics_process(delta):
	_mouse_direction = get_local_mouse_position().normalized()
	_mouse_angle = -_mouse_direction.angle_to(Vector2(1, 0))
	
	$Mouse.position = _mouse_direction * 20
	
	$Gun.flip_v = _mouse_direction.x < 0
	$Gun.rotation = _mouse_angle
	$Gun.offset.y = -5 * sign(_mouse_direction.x)
		

func _on_gun_animation_finished():
	if $Gun.animation == 'shoot':
		$Gun.play('idle')
		
	elif $Gun.animation == 'reload':
		var ammo_backup = get_parent().total_ammo
		var current = ammo
		var faltando = 10 - current
		
		if ammo_backup < faltando:
			get_parent().total_ammo = 0
			ammo = ammo_backup
			
		else:
			get_parent().total_ammo -= faltando
			ammo += faltando
			
		$Gun.animation = 'idle'

func shoot():
	if ammo <= 0:
		return
		
	$Gun.play('shoot')
	$GunPlayer.play()
	Bullet.spawn($Mouse.global_position, _mouse_angle, get_tree().root, 5)
	ammo -= 1

func reload():
		
	if ammo >= 10:
		return
	if get_parent().total_ammo <= 0:
		return
		
	$Gun.animation = 'reload'
	$Gun.play()
	$Reload1.play()


func _on_reload_1_finished():
	$Reload2.play()
