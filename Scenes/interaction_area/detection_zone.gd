extends Area2D

func _on_body_entered(body):
	print("Follow player")


func _on_body_exited(body):
	print("Stop Following player")
