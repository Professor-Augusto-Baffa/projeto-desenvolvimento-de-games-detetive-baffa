extends Node2D


func player_bullet(pos: Vector2):
	var bullet_instance = Bullet.spawn(pos, (get_global_mouse_position() - pos).angle())
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
