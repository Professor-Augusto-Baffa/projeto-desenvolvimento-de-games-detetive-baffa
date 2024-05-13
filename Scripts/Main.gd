extends Node2D

@onready var player: Player = $Player

@export var RECOIL: float = 1000
func player_bullet(pos: Vector2):
	var bullet_angle: float = (get_global_mouse_position() - pos).angle()
	var bullet_instance = Bullet.spawn(pos, bullet_angle)
	player.velocity += Vector2.from_angle(bullet_angle) * -RECOIL 
	player.move_and_slide()
	add_child(bullet_instance)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player/Camera2D.zoom = Vector2.ONE * 4
	$MusicPlayer.play()
	$AmbiancePlayer.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_music_player_finished():
	$AmbiancePlayer.play()
