extends Area2D

var hp = 50
@onready var damage_component = $DamageComponent
@export var player: Node2D

var direction: float = 0
var shots_left = 0

func hurt():
	print("BOSS HURT")

func _physics_process(delta):
	$Label.text = str(hp)
	if player:
		rotation = Vector2.DOWN.angle_to(player.global_position - global_position)
		direction = rotation + PI / 2

func shoot(n: int) -> void:
	shots_left = n
	shoot_single()

func shoot_single () -> void:
		shots_left -= 1
		$Shoot.play()
		Bullet.spawn($Nozzle.global_position, direction, get_tree().root, 5)
		$TimeBetweenShots.start()
	

func _on_time_between_shots_timeout():
	if shots_left > 0:
		shoot_single()
