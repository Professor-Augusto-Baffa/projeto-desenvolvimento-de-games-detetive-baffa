extends Area2D

func _on_body_entered(body):
	body.total_ammo += 10
	$AudioStreamPlayer2D.play()
	$AnimatedSprite2D.hide()


func _on_audio_stream_player_2d_finished():
	queue_free()
