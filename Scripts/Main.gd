extends Node2D

#@onready var player: Player = $Player

@export var available_levels : Array[LevelData]

@onready var _2d_scene = $"2DScene"

@export var RECOIL: float = 1000

# Exit the game with 'esc'
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()


func player_bullet(pos: Vector2):
	var bullet_angle: float = (get_global_mouse_position() - pos).angle()
	var bullet_instance = Bullet.spawn(pos, bullet_angle)
	#player.velocity += Vector2.from_angle(bullet_angle) * -RECOIL 
	#player.move_and_slide()
	add_child(bullet_instance)

# Called when the node enters the scene tree for the first time.
func _ready():
	#$Player/Camera2D.zoom = Vector2.ONE * 4
	#$MusicPlayer.play()
	#$AmbiancePlayer.play()
	LevelManager.main_scene = _2d_scene
	LevelManager.levels = available_levels
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_music_player_finished():
	$AmbiancePlayer.play()
