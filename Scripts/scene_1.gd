extends Node2D


func _process(delta):
	if Input.is_action_just_pressed("debug"):
		Global.goto_scene("res://Scenes/scene_2.tscn")
		pass

	$Camera2D.position.y = (int($NewPlayer.position.y) / 260) * 260 - 136


func _on_music_player_finished():
	$NewPlayer/MusicPlayer.play()
